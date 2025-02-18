import sys
import importlib.metadata
from colorama import init, Fore, Style

init()  # Initialize colorama

REQUIRED_PACKAGES = [
    'openai',
    'python-dotenv',
    'PySide6',
    'PySide6-Addons',
    'PySide6-Essentials',
    'qasync',
    'colorama',
    'markdown2',
    'pygments',
    'mistune',
    'python-markdown-math'
]

def check_versions():
    print(f"{Fore.CYAN}=== Checking Package Versions ==={Style.RESET_ALL}\n")
    
    print(f"{Fore.YELLOW}Python version: {sys.version}{Style.RESET_ALL}\n")
    
    all_ok = True
    for package in REQUIRED_PACKAGES:
        try:
            version = importlib.metadata.version(package)
            print(f"{Fore.GREEN}✓ {package}: {version}{Style.RESET_ALL}")
        except importlib.metadata.PackageNotFoundError:
            print(f"{Fore.RED}✗ {package}: Not installed{Style.RESET_ALL}")
            all_ok = False
    
    if all_ok:
        print(f"\n{Fore.GREEN}All required packages are installed!{Style.RESET_ALL}")
    else:
        print(f"\n{Fore.RED}Some packages are missing. Please install them.{Style.RESET_ALL}")

if __name__ == "__main__":
    check_versions()
