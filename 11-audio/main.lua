--[[
    GD50
    Flappy Bird Remake

    bird11
    "The Audio Update"

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move upwards slightly.
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic

-- Memanggil library push untuk untuk membuat virtual resolution
-- https://github.com/Ulydev/push
push = require 'push'

-- the "Class" library we're using will allow us to represent anything in
-- our game as code, rather than keeping track of many disparate variables and
-- methods

-- Memanggil library class untuk bisa menggunakan Class
-- https://github.com/vrld/hump/blob/master/class.lua
Class = require 'class'

-- Memanggil Class untuk mempermudah transisi dalam game agar perpidahan scene dalam game menjadi halus
require 'StateMachine'

require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

require 'Bird'
require 'Pipe'
require 'PipePair'

-- Dimensi layar fisik
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Dimensi virtual resolution
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Menyiapkan background ke 1 ke dalam variable
-- Menyiapkan variable untuk kecepatan awal background ke 1
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- Menyiapkan background ke 2 ke dalam variable
--Menyiapkan variable untuk kecepatan awal background ke 2
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- Menyiapkan variable untuk kecepatan background 1 dan background 2
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

-- Menyiapkan variable untuk pengulanngan gambar di setiap lebar 413px
local BACKGROUND_LOOPING_POINT = 413

-- global variable we can use to scroll the map
scrolling = true

function love.load()
    -- Fungsi untuk membuat tampilan menjadi lebih tajam dalam game pixel / retro
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Memanggil fungsi random by time
    math.randomseed(os.time())

    -- Fungsi untuk mengubah title dalam window
    love.window.setTitle('Fifty Bird')

    -- Menyiapkan variable agar font sudah tersetting jenis font dan ukuran font
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)

    --Fungsi untuk setting global font
    love.graphics.setFont(flappyFont)

    -- Membuat object berisikan sounds yang akan digunakan
    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- Fungsi untuk memainkan background musik secara berulang saat game di mulai
    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- Membuat tampilan game tetep proposional di berbagai tampilan window
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Menyiapkan StateMachine dalam varibale gStateMachine agar pergantina scene dapat dijalakan
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    -- Memanggil state title unutk menampikan title
    gStateMachine:change('title')

    -- Menyiapkan table untuk menangkap semua proses input di keyboard
    love.keyboard.keysPressed = {}
end

-- Fungsi untuk mengaktifkan resizable window agar tampilan mengikuti window
function love.resize(w, h)
    push:resize(w, h)
end

-- Fungsi untuk menjalakan input keyboard yang terdapat dalam table input keyboard
function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
