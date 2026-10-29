-- Pong for two players. All positions are measured in pixels, and all
-- speeds/velocities are measured in pixels per second.

local windowWidth = 800
local windowHeight = 600

local player1
local player2
local ball

local colors = {
    background = { 0.055, 0.075, 0.12 }, -- deep navy
    leftPaddle = { 0.30, 0.88, 0.78 }, -- soft turquoise
    rightPaddle = { 0.78, 0.65, 0.98 }, -- soft lavender
    ball = { 1.00, 0.91, 0.70 }, -- warm cream
    centerLine = { 0.27, 0.34, 0.45 },
    text = { 0.88, 0.92, 0.98 }
}

local initialBallSpeed = 300
local speedIncrease = 20
local maximumBallSpeed = 520

-- Reusable Axis-Aligned Bounding Box (AABB) collision check.
local function checkCollision(a, b)
    return a.x < b.x + b.width
        and a.x + a.width > b.x
        and a.y < b.y + b.height
        and a.y + a.height > b.y
end

local function setBallVelocity(speed, direction)
    -- Keep a modest vertical component so the ball does not travel flat.
    local verticalRatio = math.max(-0.75, math.min(0.75, ball.dy / ball.speed))
    local horizontalRatio = math.sqrt(1 - verticalRatio * verticalRatio)
    ball.speed = speed
    ball.dx = direction * speed * horizontalRatio
    ball.dy = verticalRatio * speed
end

local function resetBall(direction)
    ball.x = windowWidth / 2 - ball.width / 2
    ball.y = windowHeight / 2 - ball.height / 2
    ball.speed = initialBallSpeed
    ball.dx = direction * initialBallSpeed
    ball.dy = initialBallSpeed * 0.45
end

local function increaseBallSpeed()
    local direction = ball.dx >= 0 and 1 or -1
    setBallVelocity(math.min(ball.speed + speedIncrease, maximumBallSpeed), direction)
end

function love.load()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("Pong - Love2D")
    love.graphics.setBackgroundColor(colors.background)

    player1 = { x = 30, y = 250, width = 15, height = 100, speed = 360, score = 0 }
    player2 = { x = windowWidth - 45, y = 250, width = 15, height = 100, speed = 360, score = 0 }
    ball = { x = 0, y = 0, width = 18, height = 18, dx = 0, dy = 0, speed = initialBallSpeed }
    resetBall(1)
end

function love.update(dt)
    -- Move paddles with dt so their speed is measured in pixels per second.
    if love.keyboard.isDown("w") then player1.y = player1.y - player1.speed * dt end
    if love.keyboard.isDown("s") then player1.y = player1.y + player1.speed * dt end
    if love.keyboard.isDown("up") then player2.y = player2.y - player2.speed * dt end
    if love.keyboard.isDown("down") then player2.y = player2.y + player2.speed * dt end

    player1.y = math.max(0, math.min(player1.y, windowHeight - player1.height))
    player2.y = math.max(0, math.min(player2.y, windowHeight - player2.height))

    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Bounce and clamp so the ball cannot remain beyond the top/bottom edge.
    if ball.y < 0 then
        ball.y = 0
        ball.dy = math.abs(ball.dy)
    elseif ball.y + ball.height > windowHeight then
        ball.y = windowHeight - ball.height
        ball.dy = -math.abs(ball.dy)
    end

    -- Direction checks make each paddle collision respond only once while
    -- the ball overlaps it. Moving the ball outside clears the overlap.
    if ball.dx < 0 and checkCollision(ball, player1) then
        ball.x = player1.x + player1.width
        increaseBallSpeed()
        player1.score = player1.score + 1
    elseif ball.dx > 0 and checkCollision(ball, player2) then
        ball.x = player2.x - ball.width
        increaseBallSpeed()
        player2.score = player2.score + 1
    end

    -- Award a point and serve toward the player who missed.
    if ball.x + ball.width < 0 then
        player2.score = player2.score + 1
        resetBall(-1)
    elseif ball.x > windowWidth then
        player1.score = player1.score + 1
        resetBall(1)
    end
end

function love.draw()
    -- Dashed center line.
    love.graphics.setColor(colors.centerLine)
    for y = 0, windowHeight - 18, 32 do
        love.graphics.rectangle("fill", windowWidth / 2 - 2, y, 4, 18)
    end

    love.graphics.setColor(colors.leftPaddle)
    love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)
    love.graphics.setColor(colors.rightPaddle)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)
    love.graphics.setColor(colors.ball)
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)

    love.graphics.setColor(colors.text)
    love.graphics.print("Player 1  " .. player1.score, windowWidth / 2 - 150, 24, 0, 1.4, 1.4)
    love.graphics.print("Player 2  " .. player2.score, windowWidth / 2 + 35, 24, 0, 1.4, 1.4)
    love.graphics.setColor(1, 1, 1, 1)
end
