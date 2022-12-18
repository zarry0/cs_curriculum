import turtle

class Poligon:
    a = None
    def __init__(self, sides, name) -> None:
        self.sides = sides
        self.name = name
        self.angle = (sides - 2) * 180 / sides

    def draw(self):
        for i in range(self.sides):
            turtle.forward(100)
            turtle.right(180-self.angle)
        turtle.done()

square = Poligon(4,'square')
pentagon = Poligon(5, 'pentagon')

print(square.sides)
print(square.name)

#square.draw()
#pentagon.draw()

print(Poligon.a)
print(Poligon.sides)