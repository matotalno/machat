import mistune
from pygments import highlight
from pygments.lexers import get_lexer_by_name
from pygments.formatters import HtmlFormatter
from dataclasses import dataclass
from typing import List, Optional
from PySide6.QtCore import QObject, Slot, Property

@dataclass
class MarkdownBlock:
    type: str
    content: str
    language: Optional[str] = None

class MarkdownParser(QObject):
    def __init__(self):
        super().__init__()
        self.markdown = mistune.create_markdown(renderer='ast')
        
    @Slot(str, result='QVariantList')
    def parse(self, text: str) -> List[MarkdownBlock]:
        ast = self.markdown(text)
        blocks = []
        
        for node in ast:
            if node['type'] == 'paragraph':
                blocks.append(MarkdownBlock(
                    type='paragraph',
                    content=self._render_inline(node['children'])
                ))
            elif node['type'] == 'code':
                blocks.append(MarkdownBlock(
                    type='code',
                    content=node['text'],
                    language=node.get('lang')
                ))
            # Add other block types as needed
            
        return blocks
    
    def _render_inline(self, nodes) -> str:
        result = []
        for node in nodes:
            if node['type'] == 'text':
                result.append(node['text'])
            elif node['type'] == 'link':
                result.append(f'<a href="{node["link"]}">{node["text"]}</a>')
            elif node['type'] == 'emphasis':
                result.append(f'<em>{node["text"]}</em>')
            elif node['type'] == 'strong':
                result.append(f'<strong>{node["text"]}</strong>')
            # Add other inline types as needed
        return ''.join(result)
