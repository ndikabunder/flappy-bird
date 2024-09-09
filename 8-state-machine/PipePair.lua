-- Membuat class PipePair
PipePair = Class {}

-- Jarak antar pipe atas dan bawah
local GAP_HEIGHT = 90

function PipePair:init(y)
    -- Menentukan letak PipePair di sumbu x akhir layar
    self.x = VIRTUAL_WIDTH + 32

    -- nilai untuk letak sumbu y
    self.y = y

    -- Menampilakan 2 pipa atas bawah
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Menyiapkan untuk menghapus pie
    self.remove = false
end

-- Memmbuat fungsu untuk update pipe atas dan bawah
function PipePair:update(dt)
    -- cek konsisi bila jarak pipe di sumbu x lebih besar dari lebar pipe
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
