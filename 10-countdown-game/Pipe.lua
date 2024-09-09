-- Inisiasi Pipe Class
Pipe = Class {}

-- Menyiapkan gambar ke dalam variable
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

-- Kecepatan pipe dari kanan ke kiri
PIPE_SPEED = 60

-- Mengatur default tinggi dan lebar pipe
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

-- Inisiasi pipe
function Pipe:init(orientation, y)
    -- Membuat variable x untuk menentukan posisi pipe di sumbu x
    self.x = VIRTUAL_WIDTH
    self.y = y

    -- Lebar dan tinggi pipe
    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

-- Membuat fungsi untuk kecepatan gerak pipe
function Pipe:update(dt)

end

-- Membuat fungsi untuk merender pipe di layar
function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, 1, self.orientation == 'top' and -1 or 1)
end
