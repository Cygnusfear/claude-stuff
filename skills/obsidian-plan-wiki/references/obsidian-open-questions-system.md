## Open Questions System

This project tracks open questions in Obsidian comments using a consistent format so questions can be searched, referenced, and resolved in context.
- Reply in-line until the conversation is resolved.
- Multi-line is allowed if it improves readability.
- The same system is applicable to code however syntax might vary i.e. `// 🙋‍♂️` depending on the languages.

## Comment Format

```
%% 🙋‍♂️ Human question/task %% ^q-scope-topic

%% 🤖 Agent question waiting on human %% ^q-scope-topic

%% 🤖 Agent question waiting on human 🙋‍♂️ human answers %% ^q-scope-topic

%% 🤖 Agent question waiting on human 🙋‍♂️ human answers 🤖 asks more 🙋‍♂️ sure why not %% ^q-scope-topic
```

**completed** -> mark as done in-place (and optionally copy to [[research/question-archive]])

```
%% ✅ Question here → Answer here %% ^q-scope-topic
```

## Markers

| Marker | Meaning          | Who acts next  |
| ------ | ---------------- | -------------- |
| 🙋‍♂️  | Human wrote this | Agent acts     |
| 🤖     | Agent wrote this | Human responds |
| ✅      | Done             | -              |

## Rules

1. **Blank line between questions.** (Obsidian merges adjacent comments.)
2. **Every question needs a block id.** Use `^q-{scope}-{descriptor}`.
3. **Last emoji decides whose turn it is.**
4. **`✅` means done**

## Finding Questions

Terminal search:

```
rg "🙋‍♂️" docs/
rg "🤖" docs/
rg "✅" docs/
rg "%% .*%%$" docs/  # missing block IDs (lines ending with %%)
rg "🙋‍♂️" src/
```

Obsidian search:
- `🙋‍♂️` for human tasks
- `🤖` for agent questions

## Linking to a Question

```
[[features/10-core/10.06-client-prediction-spec#^q-prediction-fixed-tick|Prediction tick question]]
```
