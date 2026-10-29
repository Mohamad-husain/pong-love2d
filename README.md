# Pong Game in Love2D

## Student Information

- **Full name:** [Write your full name here]
- **Class/section:** [Write your class or section here]

## Game Description

A two-player Pong game in which players move paddles to return a ball across the screen. The ball bounces from the top and bottom walls and from either paddle. Each successful paddle hit makes the ball a little faster, up to a safe maximum, and a point is awarded when the other player misses.

## Technologies

- Lua
- LÖVE (Love2D)
- Git/GitHub

## Installation and Running

1. Install LÖVE from [love2d.org](https://love2d.org/).
2. Open a terminal in the project root—the directory containing `main.lua`.
3. Run:

   ```text
   love .
   ```

## Controls

- **W:** Move the left paddle up.
- **S:** Move the left paddle down.
- **Up Arrow:** Move the right paddle up.
- **Down Arrow:** Move the right paddle down.

## How the Game Works

- `love.load()` sets the window and initializes paddles and the ball.
- `love.update(dt)` reads the controls, moves objects, and handles collisions. LÖVE calls it repeatedly while the game runs.
- `love.draw()` paints the background, center line, paddles, ball, and scores. Drawing only displays the current state; it does not change positions.
- `checkCollision(a, b)` uses Axis-Aligned Bounding Box (AABB) collision detection. It checks whether the horizontal and vertical ranges of two rectangles overlap.
- At the top and bottom walls, the ball's vertical velocity (`dy`) changes sign and its position is clamped to the screen edge.
- A paddle hit reverses the ball's horizontal direction (`dx`) and places the ball just outside the paddle. The direction check prevents another response while the same overlap is being resolved.
- When the ball passes a paddle, the other player scores and the ball returns to the center.

## Understanding Delta Time

**Delta time**, written `dt`, is the amount of time in seconds since the previous update. LÖVE passes it to `love.update(dt)`. It is a time interval, not a speed or a position.

Games run a loop many times each second. Each cycle reads input, updates the game state, and draws a frame. The number of cycles per second is the frame rate (FPS), and it can vary with the computer's workload.

If an object moves at `300` pixels per second, its movement for one update is `speed * dt`. At 60 FPS, one frame lasts about `1/60` second, so the object moves `300 * (1/60) = 5` pixels per frame. In one second it updates about 60 times: `60 * 5 = 300` pixels. At 30 FPS, a frame lasts about `1/30` second, so it moves `300 * (1/30) = 10` pixels per frame; over 30 frames that is `30 * 10 = 300` pixels. The per-frame steps differ, but the distance per second is the same (approximately, subject to frame timing).

**Position** says where an object is, in pixels. **Speed** is how much distance it covers per second, without a direction. **Velocity** includes direction: here `dx` and `dy` are the ball's horizontal and vertical velocity components in pixels per second. Positive `dx` moves right and negative `dx` moves left; positive `dy` moves down and negative `dy` moves up, because screen coordinates increase downward. The update adds `dx * dt` to `x` and `dy * dt` to `y`.

Movement belongs in `love.update(dt)` because that function advances the game state according to elapsed time. `love.draw()` may be called at a different rate; moving objects there would make motion depend on rendering frequency and could change positions more than once per update.

## My Original Feature

After every successful paddle return, ball speed increases by 20 pixels per second. The velocity direction is preserved, and total speed is capped at 520 pixels per second so rallies become more challenging without growing uncontrollably. A new serve starts at the initial speed.

## Project Structure

```text
PongGame/
├── main.lua             # Game setup, movement, collisions, and drawing
├── README.md            # Instructions and beginner-friendly explanations
├── .gitignore           # Temporary and editor-generated files to ignore
├── screenshots/         # Place a genuine game screenshot here
└── demo/                # Place a genuine gameplay recording here
```

## Screenshot

No genuine screenshot has been captured yet. When the game is running, take a screenshot and save it as `screenshots/pong-game.png`, then use this link:

![Pong Game Screenshot](screenshots/pong-game.png)

## Demo Video

No genuine demo recording has been captured yet. Record gameplay with Windows Game Bar (`Win + Alt + R`) or another screen recorder, save it as `demo/pong-demo.mp4`, then use this link:

[Watch the Pong Game Demo](demo/pong-demo.mp4)

## GitHub Submission

Create a **public** GitHub repository named `pong-love2d`. After creating it, replace `YOUR-USERNAME` below with your GitHub username and run these commands from this project directory:

```bash
git remote add origin https://github.com/YOUR-USERNAME/pong-love2d.git
git push -u origin main
git status
```

The push is intentionally left for you to perform after creating the repository and confirming your account details.
