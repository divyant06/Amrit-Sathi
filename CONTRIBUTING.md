# 🤝 Contributing to Amrit Sathi

Welcome to **Amrit Sathi**! We are absolutely thrilled to be a part of **GirlScript Summer of Code (GSSoC)**. 

Whether you are a beginner looking for your very first merge or an intermediate developer ready to tackle state management and API integration, there is a place for you here. This document will guide you through the process of contributing effectively and professionally.

## 📌 Ground Rules & GSSoC Workflow

To keep this project organized and ensure everyone gets a fair chance to contribute, please adhere strictly to this workflow:

### 1. Claiming an Issue (Crucial Step)
* Browse the **Issues** tab and look for labels like `gssoc`, `good first issue`, `bug`, or `enhancement`.
* **DO NOT start working on an issue immediately.**
* Leave a comment on the issue saying you would like to work on it (e.g., *"Hi, I am a GSSoC participant. Can I be assigned to this issue?"*).
* **Wait to be assigned.** We will assign the issue to you. PRs submitted for unassigned issues, or issues assigned to someone else, will be closed to prevent overlapping work.

### 2. Fork and Clone
Once assigned, fork the repository to your own GitHub account, then clone it locally:
```bash
git clone [https://github.com/](https://github.com/)<your-username>/Amrit-Sathi.git
cd Amrit-Sathi
```
3. Branching
Always create a new branch for your work. Do not work directly on the main branch. Name your branch descriptively:
```bash
# For a new feature
git checkout -b feature/add-dark-mode-toggle

# For a bug fix
git checkout -b fix/map-crash-on-load
```
4. Making Changes & Committing
Write clean, well-documented code. When you are ready to commit, please use Conventional Commits to keep the history readable:
```bash
# Good examples:
git commit -m "feat: add user profile UI"
git commit -m "fix: resolve crash when offline"
git commit -m "docs: update readme with installation steps"
```
5. Push and Open a Pull Request (PR)
Push your changes to your forked repository:
```bash
git push origin <your-branch-name>
```
Go to the original Amrit Sathi repository and click Compare & pull request.

📝 Pull Request Guidelines
Link the Issue: In your PR description, type Closes #IssueNumber (e.g., Closes #12) so GitHub automatically links and closes the issue when merged.

Include Screenshots: If your PR changes the User Interface (UI), please attach "Before" and "After" screenshots in the PR description.

Be Patient: Maintainers will review your code. We might request some changes before merging—this is a normal part of the software engineering process!

💡 Need Help?
Don't hesitate to ask questions in the issue threads if you are stuck. Open source is all about learning together. We are here to help you succeed.

Thank you for contributing to Amrit Sathi! Happy coding! 🚀


---

### 2. How to Add and Update This File in Your Repository

You want this file to sit right next to your `README.md` at the very top level of your project. Here is how to add it and push it to GitHub:

**Step 1: Create the file**
1. Open your project in VS Code.
2. In the Explorer panel on the left, click the "New File" icon (or right-click in the empty space and select New File).
3. Name it exactly: **`CONTRIBUTING.md`** (All caps is the standard convention).

**Step 2: Paste the content**
Paste the markdown text I provided above into this new file and save it (`Ctrl + S` / `Cmd + S`).

**Step 3: Push it to GitHub**
Open your terminal in VS Code and run the standard git commands:

```bash
git add CONTRIBUTING.md
git commit -m "docs: add GSSoC contributing guidelines"
git push
```
Step 4: Clean up the README (Optional but recommended)
Since you now have a dedicated, detailed CONTRIBUTING.md file, you can shorten the "Contributing" section in your README.md to keep it clean. You can replace the old text in the README with something simple like this:

🤝 Contributing
Welcome to Amrit Sathi! We are proudly participating in GirlScript Summer of Code (GSSoC).

Please read our Contributing Guidelines before submitting a Pull Request. It contains important rules about claiming issues and formatting your code.
