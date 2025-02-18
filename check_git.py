import subprocess
from colorama import init, Fore, Style

init()  # Initialize colorama

def print_colored(text, color=Fore.WHITE):
    print(f"{color}{text}{Style.RESET_ALL}")

def check_status():
    print_colored("\n=== Git Status Check ===\n", Fore.CYAN)
    
    try:
        # Proveri trenutnu granu
        branch = subprocess.run("git branch --show-current", 
                              shell=True, capture_output=True, text=True)
        print_colored(f"Current branch: {branch.stdout}", Fore.GREEN)
        
        # Check remote changes without pulling
        print_colored("➡️ Checking remote status...", Fore.BLUE)
        run_command("git fetch")
        
        # Show status
        print_colored("\n➡️ Local vs Remote status:", Fore.BLUE)
        run_command("git status")
        
        # Show detailed diff stats if there are differences
        result = subprocess.run("git diff --stat origin/main", 
                              shell=True, capture_output=True, text=True)
        if result.stdout:
            print_colored("\n➡️ Detailed changes:", Fore.YELLOW)
            print(result.stdout)
        
        # Dodaj proveru za nepraćene fajlove
        untracked = subprocess.run("git ls-files --others --exclude-standard",
                                 shell=True, capture_output=True, text=True)
        if untracked.stdout:
            print_colored("\n⚠️ Untracked files:", Fore.YELLOW)
            print(untracked.stdout)
        
        # Dodaj proveru za stashed promene
        stash_list = subprocess.run("git stash list", 
                                  shell=True, capture_output=True, text=True)
        if stash_list.stdout:
            print_colored("\n📦 Stashed changes:", Fore.MAGENTA)
            print(stash_list.stdout)
        
        # Dodaj proveru za lokalne promene
        local_changes = subprocess.run("git diff --name-status", 
                                     shell=True, capture_output=True, text=True)
        if local_changes.stdout:
            print_colored("\n📝 Modified files:", Fore.CYAN)
            print(local_changes.stdout)
    
    except Exception as e:
        print_colored(f"ERROR: {str(e)}", Fore.RED)
    
    input("\nPritisnite Enter za izlaz...")

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

if __name__ == "__main__":
    check_status()