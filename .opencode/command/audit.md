---
description: Run a comprehensive audit of the codebase for gaps, anti-patterns, and code smells
subtask: true
---

I'd like you to run a full audit of this problem - identify any gaps or areas that are deprecated, todo, fixme. I also want you to audit the codebase for any architectural anti-patterns. And also find confusing and problematic usage of types. Flag code smells.

The approach to this works as follows:
1. Start with a comprehensive todo list of filenames relevant to the topic
2. Create a looping task with X iterations (amount of ALL files)
   - Create a task for yourself to check each file and think hard about it
   - DO NOT EDIT THE FILE
   - Critically assess if you've fully audited the file
   - If you find more files to audit, add them to this todo list
   - Mark the file off the todo list when done
3. Repeat this process until you've checked all the files
