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
    print_colored("\n=== GitHub Files Push Tool ===\n", Fore.CYAN)  # Updated title
    
    # Add version info
    version = subprocess.run("git --version", 
                           shell=True, capture_output=True, text=True)
    print_colored(f"Using {version.stdout.strip()}\n", Fore.CYAN)
    
    # Check current branch
    branch = subprocess.run("git branch --show-current", 
                          shell=True, capture_output=True, text=True)
    print_colored(f"Current branch: {branch.stdout}", Fore.GREEN)
    
    # Add branch protection
    if branch.stdout.strip() not in ['main', 'master']:
        confirm = input(f"You're on branch '{branch.stdout.strip()}'. Continue? (y/n): ")
        if confirm.lower() != 'y':
            print_colored("Operation cancelled", Fore.YELLOW)
            return
    
    # Proveri git status pre početka
    if not run_command("git status"):
        print_colored("ERROR: Not a git repository or git not installed", Fore.RED)
        return
        
    # Proveri remote connection
    if not run_command("git remote -v"):
        print_colored("ERROR: No remote repository configured", Fore.RED)
        return
    
    # Add all changes
    print_colored("➡️ Adding changes...", Fore.BLUE)
    if not run_command("git add ."):
        return
    
    # Show status
    print_colored("\n➡️ Current status:", Fore.BLUE)
    run_command("git status")
    
    # Create commit
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    custom_msg = input("Enter custom commit message (or press Enter for timestamp): ").strip()
    commit_msg = custom_msg if custom_msg else f"Update {timestamp}"
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