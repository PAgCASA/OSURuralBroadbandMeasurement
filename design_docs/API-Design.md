# API Design

There are several main events that we need to deal with between the backend and app:

- Speed test
- Document data capture (photo of bill and other information)
- Submit challenge request (if consumer feels like they aren't getting the speeds they requested)
- Get challenge status (this could be several sub-queries, but can be filled out as we learn more)



Speed test data will look very similar to the FCC data but in our own format:

```json
{
  "TODO": "SYNC WITH ACTUAL PLAN"
}
```