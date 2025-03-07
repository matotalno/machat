import uuid
import asyncio
import logging
import json
import os
from datetime import datetime
from dataclasses import dataclass
from PySide6.QtCore import QObject, Signal, Slot, Property, QAbstractListModel, Qt, QModelIndex

# Relativni import umesto apsolutnog
from ..api.openai_client import OpenAIClient

logger = logging.getLogger(__name__)

@dataclass
class ChatSession:
    id: str
    title: str
    messages: list = None
    
    def __post_init__(self):
        if self.messages is None:
            self.messages = []
        # Dodaj role ako ne postoji
        for msg in self.messages:
            if "role" not in msg:
                msg["role"] = "user" if msg.get("is_user", True) else "assistant"

class MessageModel(QAbstractListModel):
    MessageRole = Qt.UserRole + 1
    IsUserRole = Qt.UserRole + 2
    TimestampRole = Qt.UserRole + 3
    RoleRole = Qt.UserRole + 4  # Dodajemo role za OpenAI format
    lastMessageChanged = Signal()  # Dodajemo novi signal

    def __init__(self, parent=None):
        super().__init__(parent)
        self._messages = []

    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid() or index.row() >= len(self._messages):
            return None

        message = self._messages[index.row()]
        if role == self.MessageRole:
            return message["text"]
        elif role == self.IsUserRole:
            return message["is_user"]
        elif role == self.TimestampRole:
            return message["timestamp"]
        elif role == self.RoleRole:
            return message["role"]
        
        return None

    def roleNames(self):
        return {
            self.MessageRole: b"message",
            self.IsUserRole: b"isUser",
            self.TimestampRole: b"timestamp",
            self.RoleRole: b"role"
        }

    def rowCount(self, parent=QModelIndex()):
        return len(self._messages)

    def add_message(self, text, is_user=True):
        role = "user" if is_user else "assistant"
        self.beginInsertRows(QModelIndex(), len(self._messages), len(self._messages))
        self._messages.append({
            "text": text,
            "is_user": is_user,
            "timestamp": datetime.now().strftime("%H:%M"),  # Timestamp se dodaje
            "role": role  # Eksplicitno dodajemo role
        })
        self.endInsertRows()

    def update_last_ai_message(self, text):
        if self._messages and not self._messages[-1]["is_user"]:
            self._messages[-1]["text"] = text
            index = self.index(len(self._messages) - 1, 0)
            self.dataChanged.emit(index, index, [self.MessageRole])
            self.lastMessageChanged.emit()  # Emitujemo signal

class SessionModel(QAbstractListModel):
    TitleRole = Qt.UserRole + 1
    IdRole = Qt.UserRole + 2
    
    def __init__(self):
        super().__init__()
        self._sessions = []
    
    def roleNames(self):
        return {
            self.TitleRole: b'title',
            self.IdRole: b'sessionId'
        }

    # Dodajemo implementaciju rowCount
    def rowCount(self, parent=QModelIndex()):
        return len(self._sessions)

    # Dodajemo implementaciju data
    def data(self, index, role=Qt.DisplayRole):
        if not index.isValid() or index.row() >= len(self._sessions):
            return None

        session = self._sessions[index.row()]
        if role == self.TitleRole:
            return session.title
        elif role == self.IdRole:
            return session.id
        
        return None
    
    def addSession(self, session: ChatSession):
        self.beginInsertRows(QModelIndex(), len(self._sessions), len(self._sessions))
        self._sessions.append(session)
        self.endInsertRows()

class QMLBridge(QObject):
    isTypingChanged = Signal(bool)
    currentSessionChanged = Signal()
    sessionDeleted = Signal(str)  # Dodati samo ovaj signal
    messageReceived = Signal()  # Dodaj novi signal

    def __init__(self, loop=None):
        super().__init__()
        if loop is None:
            raise RuntimeError("Event loop mora biti prosleđen!")
        self._loop = loop
        self.openai_client = OpenAIClient()
        self.chat_model = MessageModel()
        self.session_model = SessionModel()  # Vrati nazad na session_model umesto _session_model
        self._current_session = None
        
        current_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        self.sessions_file = os.path.join(current_dir, "sessions.json")
        logger.debug(f"Using sessions file at: {self.sessions_file}")
        
        self._load_sessions()
        logger.debug("QMLBridge initialized")

    def _load_sessions(self):
        if os.path.exists(self.sessions_file):
            with open(self.sessions_file, 'r') as f:
                data = json.load(f)
                for session_data in data:
                    # Dodaj role svim porukama ako ne postoji
                    for msg in session_data.get('messages', []):
                        if "role" not in msg:
                            msg["role"] = "user" if msg.get("is_user", True) else "assistant"
                    session = ChatSession(
                        id=session_data['id'],
                        title=session_data['title'],
                        messages=session_data['messages']
                    )
                    self.session_model.addSession(session)
        else:
            self.createNewChat()

    def _save_sessions(self):
        try:
            logger.debug("Saving sessions...")
            data = [{
                'id': session.id,
                'title': session.title,
                'messages': session.messages if session.messages else []
            } for session in self.session_model._sessions]
            
            with open(self.sessions_file, 'w') as f:
                json.dump(data, f, indent=2)  # Added indent for better readability
            logger.debug("Sessions saved successfully")
        except Exception as e:
            logger.error(f"Error saving sessions: {e}", exc_info=True)

    @Slot(str)
    def sendMessage(self, message):
        if not message.strip():
            return
            
        try:
            logger.debug(f"Sending message: {message}")
            # Add message to chat model
            self.chat_model.add_message(message, True)
            self.chat_model.add_message("", False)
            
            # Update current session messages
            if self._current_session:
                self._current_session.messages = self.chat_model._messages.copy()
                self._save_sessions()  # Save after adding message
            
            if self._loop and self._loop.is_running():
                self._loop.create_task(self._handle_message(message))
            else:
                logger.error("Event loop nije aktivan!")
                
        except Exception as e:
            logger.error(f"Error in sendMessage: {e}", exc_info=True)

    def get_conversation_messages(self):
        """Konvertuj poruke u format za OpenAI API"""
        messages = []
        for msg in self.chat_model._messages:
            # Proveri da li postoji role, ako ne postoji dodeli default
            role = msg.get("role", "user" if msg.get("is_user", True) else "assistant")
            messages.append({
                "role": role,
                "content": msg["text"]
            })
        return messages

    async def _handle_message(self, message):
        try:
            self.isTypingChanged.emit(True)
            response = ""
            buffer = ""
            last_update = 0
            MIN_UPDATE_INTERVAL = 0.1  # 100ms minimum između update-ova
            
            # Uzmi poruke iz konverzacije
            conversation_messages = self.get_conversation_messages()
            
            async for token in self.openai_client.get_streaming_response(conversation_messages):
                response += token
                buffer += token
                
                current_time = asyncio.get_event_loop().time()
                time_since_update = current_time - last_update
                
                if time_since_update >= MIN_UPDATE_INTERVAL:
                    self.chat_model.update_last_ai_message(response)
                    self.messageReceived.emit()
                    last_update = current_time
                    buffer = ""
                    
                    # Sporiji streaming
                    await asyncio.sleep(0.03)  # 30ms delay
            
            # Finalni update
            if buffer:
                self.chat_model.update_last_ai_message(response)
                self.messageReceived.emit()
                await asyncio.sleep(0.1)  # Mali delay na kraju
                
        except Exception as e:
            logger.error(f"Error in _handle_message: {e}", exc_info=True)
            self.chat_model.update_last_ai_message(f"Greška: {str(e)}")
        
        finally:
            self.isTypingChanged.emit(False)

    @Slot()
    def createNewChat(self):
        try:
            logger.debug("===== Starting createNewChat =====")
            logger.debug(f"Current event loop: {self._loop}")
            logger.debug(f"Loop running: {self._loop.is_running() if self._loop else 'No loop'}")
            
            # Provera trenutnog stanja
            logger.debug(f"Current session before: {self._current_session.id if self._current_session else 'None'}")
            logger.debug(f"Number of sessions before: {len(self.session_model._sessions)}")
            
            # Kreiraj novu sesiju
            title = f"Novi razgovor #{len(self.session_model._sessions) + 1}"
            new_session = ChatSession(id=str(uuid.uuid4()), title=title, messages=[])
            logger.debug(f"Created new session object: {new_session.id}")
            
            try:
                # Dodaj u model
                self.session_model.addSession(new_session)
                logger.debug("Session added to model")
                
                # Očisti poruke
                logger.debug("Clearing message model...")
                self.chat_model.beginResetModel()
                self.chat_model._messages = []
                self.chat_model.endResetModel()
                logger.debug("Message model cleared")
                
                # Postavi novu sesiju
                logger.debug(f"Setting current session to: {new_session.id}")
                self._current_session = new_session
                logger.debug("Current session set")
                
                # Sačuvaj promene
                logger.debug("Saving sessions...")
                self._save_sessions()
                logger.debug("Sessions saved")
                
                # Emituj signal
                logger.debug("Emitting currentSessionChanged...")
                self.currentSessionChanged.emit()
                logger.debug("Signal emitted")
                
            except Exception as inner_e:
                logger.error(f"Inner exception in createNewChat: {inner_e}", exc_info=True)
                raise
                
        except Exception as e:
            logger.error(f"Error in createNewChat: {e}", exc_info=True)
            import traceback
            logger.error(f"Traceback: {traceback.format_exc()}")

    @Slot(str)
    def selectSession(self, session_id):
        try:
            logger.debug(f"===== Starting selectSession: {session_id} =====")
            if not session_id:
                return

            # Save current session before switching
            if self._current_session:
                self._current_session.messages = self.chat_model._messages.copy()
                self._save_sessions()

            # Find new session
            new_session = next((s for s in self.session_model._sessions 
                              if s.id == session_id), None)
            
            if not new_session:
                return

            # Update message model with new session messages
            self.chat_model.beginResetModel()
            self.chat_model._messages = new_session.messages.copy() if new_session.messages else []
            self.chat_model.endResetModel()

            # Set new session
            self._current_session = new_session
            self._save_sessions()  # Save after switching
            self.currentSessionChanged.emit()
            
        except Exception as e:
            logger.error(f"Error in selectSession: {e}", exc_info=True)

    @Property("QVariant", notify=currentSessionChanged)
    def current_session(self):
        """Property koji vraća trenutnu sesiju kao QVariant"""
        try:
            return self._current_session
        except Exception as e:
            logger.error(f"Error in current_session getter: {e}")
            return None

    @Property(str, notify=currentSessionChanged)
    def current_session_id(self):
        """Property koji vraća ID trenutne sesije ili prazan string"""
        if self._current_session is None:
            return ""
        return self._current_session.id

    @Property(str, notify=currentSessionChanged)
    def current_session_title(self):
        return self._current_session.title if self._current_session else ""

    @Slot(str)
    def deleteSession(self, session_id):
        try:
            logger.debug(f"Deleting session: {session_id}")
            
            # Find session index
            index = -1
            for i, session in enumerate(self.session_model._sessions):
                if session.id == session_id:
                    index = i
                    break
                    
            if index >= 0:
                # Prvo postavi drugi current session ako brišemo trenutni
                if self._current_session and self._current_session.id == session_id:
                    # Nađi prvu dostupnu sesiju koja nije ova koju brišemo
                    next_session = next(
                        (s for s in self.session_model._sessions 
                         if s.id != session_id), 
                        None
                    )
                    self._current_session = next_session
                
                # Sada bezbedno briši
                self.session_model.beginRemoveRows(QModelIndex(), index, index)
                removed_session = self.session_model._sessions.pop(index)
                self.session_model.endRemoveRows()
                
                # Sačuvaj promene
                self._save_sessions()
                
                # Ako nema više sesija, kreiraj novu
                if not self.session_model._sessions:
                    self.createNewChat()
                elif self._current_session:
                    # Selektuj trenutnu sesiju
                    self.selectSession(self._current_session.id)
                    
                logger.debug(f"Session successfully deleted: {session_id}")
                
        except Exception as e:
            logger.error(f"Error deleting session: {e}", exc_info=True)
