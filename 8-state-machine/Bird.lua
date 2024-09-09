-- Membuat class bird
Bird = Class {}

-- Membbuat variable gravitasi untuk menentukan kekuatan gravitasi
local GRAVITY = 4

-- Membuat fungsi ini inisiasi class Bird
function Bird:init()
    -- Memanggil gambar
    self.image = love.graphics.newImage('bird.png')
    -- Membuat lebar bird sesuai gambar
    self.width = self.image:getWidth()
    -- Membuat tinggi bird sesuai gambar
    self.height = self.image:getHeight()

    -- Menentukan letak bird disumbu x ketika ditampilak pertama dilayar
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    -- Menentukan letak bird disumbu y ketika ditampilak pertama dilayar
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Membuat variable untuk menentukan kecepatan sumbu y
    self.dy = 0
end

function Bird:collides(pipe)
    -- angka 2 adalah offset kiri dan atas
    -- angka 4 adalah offset kanan dan bawah
    -- kedua offset digunakan untuk mengecilkan kotak pembatas untuk memberi pemain
    -- sedikit kelonggaran dengan tabrakan
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
            return true
        end
    end

    return false
end

-- Membuat fungsi gravitasi
function Bird:update(dt)
    -- Memberikan kecepatan gravitasi
    self.dy = self.dy + GRAVITY * dt

    -- Memberikan kecepatan disumbu y agar bird bisa naik
    if love.keyboard.wasPressed('space') then
        self.dy = -1
    end

    -- Memberikan kecepatan posisi gravitasi di sumbu Y
    self.y = self.y + self.dy
end

-- Membuat fungsi menampilkan bird
function Bird:render()
    -- Membuat fungsi menampilkan bird (Gambar, sumbu x, sumbu y)
    love.graphics.draw(self.image, self.x, self.y)
end
