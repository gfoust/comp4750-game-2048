# Stage 5

## Track largest probability
- Add `max_power` variable
- Increment when merging
- Throw out `goal_reached`

## Pick starting power
- Make array of probabilities
  ```gd
  const POWER_PROBABILITIES = [
    [ 100,  0,  0,  0 ],
    [ 100,  0,  0,  0 ],
    [  95,  5,  0,  0 ],
    [  90, 10,  0,  0 ],
    [  88, 12,  0,  0 ],
    [  85, 15,  0,  0 ],
    [  83, 15,  2,  0 ],
    [  82, 15,  3,  0 ],
    [  81, 15,  3,  1 ],
    [  80, 15,  3,  2 ],
    [  80, 15,  3,  2 ],
  ]
```
- Make `pick_power` function
- Use when making tile
