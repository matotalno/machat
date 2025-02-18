import subprocess
from colorama import init, Fore, Style

init()  # Initialize colorama

def print_colored(text, color=Fore.WHITE):
    print(f"{color}{text}{Style.RESET_ALL}")

def check_git_sync():    # Preimenovana funkcija za bolju jasnoću
    print_colored("\n=== Git Files Sync Check ===\n", Fore.CYAN)
    
    try:
        # Proveri trenutnu granu
        branch = subprocess.run("git branch --show-current", 
                              shell=True, capture_output=True, text=True)
        print_colored(f"Current branch: {branch.stdout}", Fore.GREEN)
        
        # Organizovane provere u logičke celine
        check_remote_status()
        check_local_changes()
        check_untracked_files()
        check_stash()
        
    except Exception as e:
        print_colored(f"ERROR: {str(e)}", Fore.RED)
    
    input("\nPritisnite Enter za izlaz...")

def check_remote_status():
    print_colored("\n➡️ Checking remote status...", Fore.BLUE)
    run_command("git fetch")
    run_command("git status")

def check_local_changes():
    result = subprocess.run("git diff --stat origin/main", 
                          shell=True, capture_output=True, text=True)
    if result.stdout:
        print_colored("\n➡️ Detailed changes:", Fore.YELLOW)
        print(result.stdout)

def check_untracked_files():
    untracked = subprocess.run("git ls-files --others --exclude-standard",
                             shell=True, capture_output=True, text=True)
    if untracked.stdout:
        print_colored("\n⚠️ Untracked files:", Fore.YELLOW)
        print(untracked.stdout)

def check_stash():
    stash_list = subprocess.run("git stash list", 
                              shell=True, capture_output=True, text=True)
    if stash_list.stdout:
        print_colored("\n📦 Stashed changes:", Fore.MAGENTA)
        print(stash_list.stdout)

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
    check_git_sync()    # Ažurirano ime funkcije