-- Memanggil library push untuk virtual resolusi
push = require 'push'

-- Ukuran layar game
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Ukuran virtual layar game
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Menyiapkan gambar yang akan dipakai
-- Menyiapkan background
local background = love.graphics.newImage('background.png')
-- Menyiapkan variable untuk parallax
local backgroundScroll = 0

-- Mennyiapkan ground
local ground = love.graphics.newImage('ground.png')
-- Menyiapkan variable untuk parallax
local groundScroll = 0

-- Menyiapkan variable background parallax speed
local BACKGROUND_SCROLL_SPEED = 30
-- Menyiapkan variable ground parallax speed
local GROUND_SCROLL_SPEED = 60

-- Menyiapkan variable untuk melooping background
local BACKGROUND_LOOPING_POINT = 413 -- ukuran background

function love.load()
    -- Memberikan filter pada game agar terlihat lebih blur
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Memberikan judul pada window game
    love.window.setTitle('Flappy Bird')

    -- Menyiapkan window agar ukuran window merender ukuran virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true -- Membuat agar window game daapt dibesar dan dikecilkan
    })
end

-- Membuat fungsi resizable
function love.resize(w, h)
    push:resize(w, h)
end

-- Membuat fungsi agar game akan langsung keluar ketika dipencet esc
function love.keyboard(key)
    if key == 'escape' then
        love.event.quit()
    end
end

-- Fungsi untuk merender / memperbarui game setiap detik dan frame
function love.update(dt)
    -- Memberikan nilai kepada backgroundScroll untuk menetukan gerak
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

    -- Memberikan nilai kepada groundScroll untuk menentukan gerak
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
end

-- Membuat fungsi untuk merender UI
function love.draw()
    -- Fungsi push:start untuk memulai merender
    push:start()

    -- Fungsi untuk merender background yang sudah kita siapkan
    love.graphics.draw(background, -backgroundScroll, 0) -- (File gambar, sumbu x, sumbu y)

    -- Fungsi untuk merender background yang sudah kita siapkan
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16) -- (File gambar, sumbu x, sumbu y)

    -- Fungsi push:finish untuk mengehentikan merender
    push:finish()
end
