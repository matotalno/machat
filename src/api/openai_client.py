import os
import logging
import asyncio  # Dodaj import
from openai import AsyncOpenAI
from dotenv import load_dotenv

logger = logging.getLogger(__name__)

class OpenAIClient:
    def __init__(self):
        # Učitaj .env fajl iz root direktorijuma
        dotenv_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), '.env')
        load_dotenv(dotenv_path)
        
        # Uzmi API ključ iz environment varijable
        self.api_key = os.getenv('OPENAI_API_KEY')
        if not self.api_key:
            raise ValueError("OPENAI_API_KEY nije pronađen u .env fajlu")
        
        self.client = AsyncOpenAI(api_key=self.api_key)
        self.model = os.getenv('OPENAI_MODEL', 'gpt-4-turbo-preview')
        self.temperature = float(os.getenv('TEMPERATURE', '0.7'))
        self.max_tokens = int(os.getenv('MAX_TOKENS', '2000'))
        
        logger.info(f"OpenAI Client inicijalizovan sa modelom: {self.model}")
        
    async def get_streaming_response(self, messages):
        try:
            if not messages:
                raise ValueError("Empty conversation")

            # Novi format za system message
            system_message = {
                "role": "system", 
                "content": "You are a helpful assistant. Always respond in Serbian language. Maintain context of the entire conversation."
            }
            
            # Fix: Proveri da li poruka ima "text" ili "content" ključ
            conversation = [system_message] + [
                {
                    "role": msg.get("role", "user" if msg.get("is_user", True) else "assistant"),
                    "content": msg.get("text", msg.get("content", "")).strip()
                } 
                for msg in messages if msg.get("text", msg.get("content", "")).strip()
            ]
            
            logger.debug(f"Sending conversation with {len(conversation)} messages")
            
            response = await self.client.chat.completions.create(
                model=self.model,
                messages=conversation,
                stream=True,
                temperature=self.temperature,
                max_tokens=self.max_tokens
            )
            
            async for chunk in response:
                if chunk.choices[0].delta.content:
                    # Duži delay između tokena
                    await asyncio.sleep(0.03)  # 30ms delay za prirodniji efekat
                    yield chunk.choices[0].delta.content

        except Exception as e:
            logger.error(f"API Error: {e}", exc_info=True)
            yield f"Error: {str(e)}"
