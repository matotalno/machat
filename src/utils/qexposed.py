from PySide6.QtCore import Property, Signal, Slot, QObject
from typing import Any, Callable, TypeVar, Union

T = TypeVar('T')

def exposed_property(
    type_: Any,
    notify_signal: Signal = None,
    getter: Callable[[], T] = None,
    setter: Callable[[T], None] = None,
    doc: str = ""
) -> Property:
    """Dekorator za kreiranje Qt property koji će biti dostupan u QML-u"""
    
    def decorator(func: Callable) -> Property:
        if getter is None and setter is None:
            # Ako nemamo getter/setter, func je getter
            return Property(type_, func, notify=notify_signal, doc=doc)
        else:
            # Ako imamo getter/setter, koristimo njih
            return Property(type_, getter, setter, notify=notify_signal, doc=doc)
    
    return decorator

def exposed_slot(*types: Any, result: Any = None) -> Callable:
    """Dekorator za kreiranje Qt slota koji će biti dostupan u QML-u"""
    
    def decorator(func: Callable) -> Slot:
        if result:
            return Slot(*types, result=result)(func)
        return Slot(*types)(func)
    
    return decorator

def exposed_signal(*types: Any) -> Signal:
    """Helper za kreiranje Qt signala koji će biti dostupan u QML-u"""
    return Signal(*types)
