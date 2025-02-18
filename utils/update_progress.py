import re
from datetime import datetime

class ProgressTracker:
    def __init__(self):
        self.progress_file = "c:/modern-ai-chat/PROGRESS.md"
        self.current_component = None
        self.implemented_features = []
        self.issues = []
        self.pending_tasks = []
    
    def start_component(self, component_name):
        """Započinje praćenje rada na komponenti"""
        self.current_component = component_name
        print(f"📝 Praćenje implementacije za: {component_name}")
    
    def add_implemented(self, feature):
        """Dodaje implementiranu funkcionalnost"""
        if self.current_component:
            self.implemented_features.append({
                'component': self.current_component,
                'feature': feature,
                'time': datetime.now()
            })
    
    def add_issue(self, component, description, severity='HIGH'):
        """Dodaje problem koji je otkriven tokom implementacije"""
        self.issues.append({
            'component': component,
            'description': description,
            'severity': severity,
            'time': datetime.now(),
            'status': 'OPEN'
        })
    
    def mark_pending(self, component, feature, reason):
        """Označava task kao nedovršen sa razlogom"""
        self.pending_tasks.append({
            'component': component,
            'feature': feature,
            'reason': reason,
            'time': datetime.now()
        })
    
    def update_progress(self):
        """Ažurira PROGRESS.md sa svim promenama"""
        with open(self.progress_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Ažuriranje implementiranih funkcionalnosti
        for impl in self.implemented_features:
            task_pattern = f"- \\[([ x])\\] {impl['feature']}"
            content = re.sub(task_pattern, f"- [x] {impl['feature']}", content)
        
        # Dodavanje sekcije za probleme ako postoje
        if self.issues:
            issues_section = "\n### ⚠️ TRENUTNI PROBLEMI\n\n"
            for issue in self.issues:
                issues_section += f"- [{issue['severity']}] {issue['component']}: {issue['description']}\n"
            
            # Ubaci sekciju nakon trenutnog stanja
            content = re.sub(
                r"(## TRENUTNO STANJE.*?)\n##",
                f"\\1\n{issues_section}\n##",
                content,
                flags=re.DOTALL
            )
        
        # Dodavanje sekcije za nedovršene taskove
        if self.pending_tasks:
            pending_section = "\n### 🚧 NEDOVRŠENI TASKOVI\n\n"
            for task in self.pending_tasks:
                pending_section += f"- {task['component']} - {task['feature']}\n  Razlog: {task['reason']}\n"
            
            content = re.sub(
                r"(## TRENUTNO STANJE.*?)\n##",
                f"\\1\n{pending_section}\n##",
                content,
                flags=re.DOTALL
            )
        
        with open(self.progress_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"✅ Progress.md ažuriran:")
        print(f"  - {len(self.implemented_features)} novih funkcionalnosti")
        print(f"  - {len(self.issues)} problema")
        print(f"  - {len(self.pending_tasks)} nedovršenih taskova")
        
        # Reset lista
        self.implemented_features = []
        self.issues = []
        self.pending_tasks = []

# Globalna instanca tracker-a
tracker = ProgressTracker()

# Primer korišćenja:
if __name__ == "__main__":
    # Kada počnemo rad na komponenti
    tracker.start_component("SidebarView.qml")
    
    # Kada implementiramo neku funkcionalnost
    tracker.add_implemented("Širina: 240-300px")
    tracker.add_implemented("Logo/header (50-60px)")
    
    # Dodavanje problema
    tracker.add_issue("SidebarView.qml", "Problem sa responzivnošću na manjim ekranima", "MEDIUM")
    
    # Označavanje nedovršenog taska
    tracker.mark_pending("SidebarView.qml", "Search funkcionalnost", "Čeka implementaciju backend filtera")
    
    # Na kraju ažuriramo progress
    tracker.update_progress()
