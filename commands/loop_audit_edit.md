I'd like you to run a full audit of the codebase- identify any gaps or areas that are deprecated, todo, fixme. I also want you to aud the codebase for any architectural anti-patterns. And also find confusing and problematic usage of types. Flag code smells.

The approach to this works as follows -> USE A TASK TO COMPLETE THE FOLLOWING ->:
1. you check ALL the filenames in the code and you make a comprehensive todo list of each filenames
2. you create a looping task with X interations (amount of ALL files)
- you create a task for yourself to check each file and think hard about it
- check your memory on each file for context
- if you've **edited** the file, type check it for errors
- you critically assess if you've fully audited the file
- you can then mark the file off the todo list
- you then store in your memory your assessment of the file- PLUS an updated todo list minus the file you've just checked
3. you repeat this process until you've checked all the files