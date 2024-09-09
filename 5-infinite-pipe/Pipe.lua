-- Inisiasi Pipe Class
Pipe = Class {}

-- Menyiapkan gambar ke dalam variable
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- Memberikan kecepatan saat pipe bergerak
local PIPE_SCROLL = -60

-- Inisiasi pipe
function Pipe:init()
    -- Membuat variable x untuk menentukan posisi pipe di sumbu x
    self.x = VIRTUAL_WIDTH

    -- Membuat variable y untuk menentukan posisi pipe di sumbu y
    self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

    -- Membuat variabel untuk menentukan lebar gambar di layar
    self.width = PIPE_IMAGE:getWidth() -- Menggunakan lebar asli gamabr
end

-- Membuat fungsi untuk kecepatan gerak pipe
function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

-- Membuat fungsi untuk merender pipe di layar
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y)) -- Lokasi gambar, sumbu x, sumbu y
end
