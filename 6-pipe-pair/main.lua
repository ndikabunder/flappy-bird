-- Memanggil library push untuk virtual resolusi
push = require 'push'

-- Memanggil library class
Class = require 'class'

-- Memanggil class bird
require 'Bird'

-- Mamanggil class Pipe
require 'Pipe'

-- Memanggil class PipePair
require 'PipePair'

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

-- Membuar local variable untuk menggunakan Bird class
local Bird = Bird()

-- Membuat table variable untuk menampung pipes yang muncul
local pipePairs = {}

-- Membuat variable untuk menentukan jarak pipe
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- Membuat variable untuk menentukan waktu pipe akan keluar
local spawnTimer = 0

-- Scrolling variable berguna untuk cek tabrakan dan mengehentikan game
local scrolling = true

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

    -- Inisiasi tabel input
    love.keyboard.keysPressed = {}
end

-- Membuat fungsi resizable
function love.resize(w, h)
    push:resize(w, h)
end

-- Membuat fungsi agar game akan langsung keluar ketika dipencet esc
function love.keypressed(key)
    -- Fungsi mengkoleksi data player saat memencet keyboard
    love.keyboard.keysPressed[key] = true

    -- Fungsi ketika player memencet esc
    if key == 'escape' then
        -- fungsi game keluar
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    -- Membuat fungsi jika keypressed ada action maka return true
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

-- Fungsi untuk merender / memperbarui game setiap detik dan frame
function love.update(dt)
    -- Pengecekan ketika tabrakan
    if scrolling then
        -- Memberikan nilai kecepatan kepada backgroundScroll untuk menetukan gerak background
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

        -- Memberikan nilai kecepatan kepada groundScroll untuk menentukan gerak ground
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        -- Menentukan timer untuk keluarnya pipes
        spawnTimer = spawnTimer + dt

        -- Cek kondisi bila spawnTimer lebih dari 2 akan muncul pipe
        if spawnTimer > 2 then
            -- Membuat kondisi agar jarak pipa tidak terlalu jauh
            -- dan jarak diatas pipa tidak lebih dari 10
            -- dan jarak bawah tidak leih 90
            local y = math.max(-PIPE_HEIGHT + 10,
                math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = y

            -- Memasukkan pipe yang muncul ke table
            table.insert(pipePairs, PipePair(y))
            -- Mengembalikan spwan timer ke 0 setelah pipe muncul
            spawnTimer = 0
        end

        -- Memanggil fungsi gravitasi dari class bird
        Bird:update(dt)

        -- Pengulanangan untuk mengecek pipes sudah keluar layar disebelah kiri
        for k, pipe in pairs(pipePairs) do
            -- Memperbarui object pipa
            pipe:update(dt)

            -- Cek kondisi jika bird bertabrakan dengan pipe
            for l, pipe in pairs(pair.pipes) do
                if Bird:collides(pipe) then
                    -- Menghentikan game saat tabrakan terjadi
                    scrolling = false
                end
            end
        end

        -- Mengecek kondisi bila pipa sudah keluar dari layar maka pipa akan dihapus
        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
    end

    -- Reset input tabel
    love.keyboard.keysPressed = {}
end

-- Membuat fungsi untuk merender UI
function love.draw()
    -- Fungsi push:start untuk memulai merender
    push:start()

    -- Fungsi untuk merender background yang sudah kita siapkan
    love.graphics.draw(background, -backgroundScroll, 0) -- (File gambar, sumbu x, sumbu y)

    -- Pengulangan untuk merender pipa di table pipes
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    -- Fungsi untuk merender background yang sudah kita siapkan
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16) -- (File gambar, sumbu x, sumbu y)

    -- Meenggunakan fungsi class bird untuk menampilakn bird
    Bird:render()

    -- Fungsi push:finish untuk mengehentikan merender
    push:finish()
end
