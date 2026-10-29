-- Pong for two players. All positions are measured in pixels, and all
-- speeds/velocities are measured in pixels per second.

local windowWidth = 800
local windowHeight = 600

local player1
local player2
local ball
local scoreFont

local colors = {
    background = { 0.075, 0.085, 0.08 }, -- warm charcoal
    leftPaddle = { 1.00, 0.57, 0.24 }, -- vivid tangerine
    rightPaddle = { 0.35, 0.82, 0.60 }, -- bright mint
    ball = { 1.00, 0.96, 0.82 }, -- warm ivory
    centerLine = { 0.40, 0.43, 0.39 },
    text = { 0.96, 0.95, 0.88 }
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

local function increaseBallSpeed(direction)
    setBallVelocity(math.min(ball.speed + speedIncrease, maximumBallSpeed), direction)
end

function love.load()
    love.window.setMode(windowWidth, windowHeight)
    love.window.setTitle("Pong - Love2D")
    love.graphics.setBackgroundColor(colors.background)
    scoreFont = love.graphics.newFont(42)

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

    -- Reflect the ball at the top and bottom. The loop also handles a large
    -- dt that might move the ball through more than one wall in one update.
    local lowestY = windowHeight - ball.height
    while ball.y < 0 or ball.y > lowestY
        or (ball.y <= 0 and ball.dy < 0)
        or (ball.y >= lowestY and ball.dy > 0) do
        if ball.y < 0 then
            ball.y = -ball.y
            ball.dy = math.abs(ball.dy)
        elseif ball.y > lowestY then
            ball.y = 2 * lowestY - ball.y
            ball.dy = -math.abs(ball.dy)
        end
    end

    -- Direction checks make each paddle collision respond only once while
    -- the ball overlaps it. Moving the ball outside clears the overlap.
    if ball.dx < 0 and checkCollision(ball, player1) then
        ball.x = player1.x + player1.width
        -- A left-paddle return must send the ball toward the right player.
        increaseBallSpeed(1)
    elseif ball.dx > 0 and checkCollision(ball, player2) then
        ball.x = player2.x - ball.width
        -- A right-paddle return must send the ball toward the left player.
        increaseBallSpeed(-1)
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
    love.graphics.setFont(scoreFont)
    -- Show one large score number for each player, as in classic Pong.
    love.graphics.print(tostring(player1.score), 225, 35)
    love.graphics.print(tostring(player2.score), 575, 35)
    love.graphics.setColor(1, 1, 1, 1)
end
