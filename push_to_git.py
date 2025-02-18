import subprocess
from datetime import datetime
import os
import sys
from colorama import init, Fore, Style

init()  # Initialize colorama

def print_colored(text, color=Fore.WHITE):
    print(f"{color}{text}{Style.RESET_ALL}")

def run_command(command):
    try:
        result = subprocess.run(command, shell=True, capture_output=True, text=True)
        if result.stdout:
            print_colored(result.stdout, Fore.GREEN)
        if result.stderr:
            print_colored(f"WARNING: {result.stderr}", Fore.YELLOW)
        return result.returncode == 0
    except Exception as e:
        print_colored(f"ERROR: {str(e)}", Fore.RED)
        return False

def main():
    print_colored("\n=== GitHub Push Tool ===\n", Fore.CYAN)
    
    # Add all changes
    print_colored("➡️ Adding changes...", Fore.BLUE)
    if not run_command("git add ."):
        return
    
    # Show status
    print_colored("\n➡️ Current status:", Fore.BLUE)
    run_command("git status")
    
    # Create commit
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    commit_msg = f"Update {timestamp}"
    print_colored(f"\n➡️ Creating commit: {commit_msg}", Fore.BLUE)
    if not run_command(f'git commit -m "{commit_msg}"'):
        return
    
    # Push changes
    print_colored("\n➡️ Pushing to GitHub...", Fore.BLUE)
    if not run_command("git push"):
        return
    
    print_colored("\n✅ Successfully pushed to GitHub!", Fore.GREEN)
    input("\nPritisnite Enter za izlaz...")

if __name__ == "__main__":
    main()