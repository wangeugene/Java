✅ Solution — how to view popup logs

Follow these steps carefully:

```markdown
    1.	Go to chrome://extensions/
    2.	Make sure “Developer mode” is enabled (top right).
    3.	Find your “Hello Extensions!” extension.
    4.	Under it, click “Inspect views: hello.html” (this opens the DevTools for the popup).
    5.	Then click the extension icon in the Chrome toolbar to open the popup.
    6.	Now check the DevTools window from step 4 — your console.log(...) messages will appear there.
```

Think of your extension popup like a mini standalone web page — it’s not part of the tab you’re viewing. So it has its own JavaScript context, memory, and logs.

That’s why:
• It doesn’t show logs in the tab’s console.
• You must open DevTools attached to the popup’s window.

⸻

✅ Tip: Quick way to get there

```markdown
You can skip chrome://extensions/ and just:

1. Right-click your extension icon in the toolbar
```
