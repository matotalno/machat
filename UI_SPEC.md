# Modern AI Chat - UI Specifikacija

## Layout & Komponente

### 1. Glavni Layout
- Horizontalna podela (SidebarView | ChatView)
- Sidebar širina: 240-300px (kolapsira na <800px)
- Tamna tema: Sidebar #2f2f2f, Background #1f1f1f

### 2. SidebarView
- Logo/Header (50-60px visina)
- New Chat dugme (full width)
- Scrollable lista sesija
- Search bar
- Settings i Clear dugmad (fixed bottom)

### 3. ChatView
- Header bar (48-50px)
- Scrollable message area
- InputBar (48-60px, max 5 redova)

### 4. Message Bubbles
- AI poruke: Avatar levo, akcije ispod
- User poruke: Avatar desno
- Code blocks sa syntax highlighting
- Markdown podrška

### 5. SettingsDialog
- Modal preko cele aplikacije
- Tabs: API | UI | Advanced
- Form kontrole sa labelama
