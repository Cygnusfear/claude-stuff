I'd like you to run a full audit of this problem- identify any gaps or areas that are deprecated, todo, fixme. I also want you to audit the codebase for any architectural anti-patterns. And also find confusing and problematic usage of types. Flag code smells.

The approach to this works as follows -> USE A TASK TO COMPLETE THE FOLLOWING -> :
1. Start with a comprehensive todo list of filenames relevant to the topic
2. you create a looping task with X interations (amount of ALL files)
- you create a task for yourself to check each file and think hard about it
- check your memory on each file for context
- DO NOT EDIT THE FILE
- you critically assess if you've fully audited the file
- if you find more files to audit, add them to this todo list with the same pattern
- you can then mark the file off the todo list
- you then store in your memory your assessment of the file- PLUS an updated todo list minus the file you've just checked
3. you repeat this process until you've checked all the files