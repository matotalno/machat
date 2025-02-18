from PySide6.QtQml import qmlRegisterType
from PySide6.QtQuick import QQuickItem
from PySide6.QtCore import QObject, Property, Signal, Slot
from .chat_bridge import QMLBridge
from ..utils.markdown_parser import MarkdownParser

def register_qml_types():
    try:
        # Import QtGraphicalEffects alternativa
        from PySide6.QtQuick import QQuickGradient
        print("Using built-in PySide6 effects")
    except:
        print("Using fallback effects")
        
    # Register custom types
    qmlRegisterType(MarkdownParser, "CustomComponents", 1, 0, "MarkdownParser")
    
    # Register singletons
    markdown_parser = MarkdownParser()
    QMLBridge.markdown_parser = markdown_parser

    # Registruj putanje za QML module
    from PySide6.QtCore import QDir
    QDir.addSearchPath("components", "src/ui/qml/components")
    QDir.addSearchPath("blocks", "src/ui/qml/components/blocks")

