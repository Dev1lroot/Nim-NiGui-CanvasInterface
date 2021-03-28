import nigui, osproc, libdevgui, math, strutils, re

app.init()
var window = newWindow()


var calc_query: string

window.width = 500
window.height = 500

var control1 = newControl()
window.add(control1)

control1.widthMode = WidthMode_Fill
control1.heightMode = HeightMode_Fill

proc evaluateMath(input: string): string=
  var sum: int
  var i = 0
  var mathOperators = input.replace(re("[0-9ABCDEF]"))
  var mathNumbers = input.split(re("[^0-9ABCDEF]"))

var player = DevguiButton(x:128,y:128,h:64,w:64)
var dgui: DevguiInterface

var lcarsGold = DevguiStyle(
  d_color: rgb(0, 0, 0), 
  h_color: rgb(0, 0, 0),
  d_fontSize: 24,
  h_fontSize: 24,
  d_background: rgb(255, 154, 102),  
  h_background: rgb(200, 122, 81))

var lcarsRed = DevguiStyle(
  d_color: rgb(0, 0, 0), 
  h_color: rgb(0, 0, 0),
  d_fontSize: 24,
  h_fontSize: 24,
  d_background: rgb(200, 102, 103),  
  h_background: rgb(153, 77, 77))

var lcarsPurple = DevguiStyle(
  d_color: rgb(0, 0, 0), 
  h_color: rgb(0, 0, 0),
  d_fontSize: 24,
  h_fontSize: 24,
  d_background: rgb(203, 153, 204),  
  h_background: rgb(166, 126, 168))

dgui.createButton("btn+","+",0,64,48,48,lcarsGold)
dgui.createButton("btn-","-",64,64,48,48,lcarsGold)
dgui.createButton("btn*","*",128,64,48,48,lcarsGold)
dgui.createButton("btn:",":",192,64,48,48,lcarsGold)
dgui.createButton("btn^","^",256,64,48,48,lcarsGold)

dgui.createButton("btn0","0",0,128,48,48,lcarsRed)
dgui.createButton("btn1","1",64,128,48,48,lcarsRed)
dgui.createButton("btn2","2",128,128,48,48,lcarsRed)
dgui.createButton("btn3","3",192,128,48,48,lcarsRed)

dgui.createButton("btn4","4",0,192,48,48,lcarsRed)
dgui.createButton("btn5","5",64,192,48,48,lcarsRed)
dgui.createButton("btn6","6",128,192,48,48,lcarsRed)
dgui.createButton("btn7","7",192,192,48,48,lcarsRed)

dgui.createButton("btnEquals","=",256,128,48,112,lcarsPurple)

dgui.createButton("btn8","8",0,256,48,48,lcarsRed)
dgui.createButton("btn9","9",64,256,48,48,lcarsRed)
dgui.createButton("btnA","A",128,256,48,48,lcarsRed)
dgui.createButton("btnB","B",192,256,48,48,lcarsRed)

dgui.createButton("btnC","C",0,320,48,48,lcarsRed)
dgui.createButton("btnD","D",64,320,48,48,lcarsRed)
dgui.createButton("btnE","E",128,320,48,48,lcarsRed)
dgui.createButton("btnF","F",192,320,48,48,lcarsRed)

dgui.createButton("btnClear","<",256,256,48,112,lcarsPurple)

proc drawCalcQuery(event: DrawEvent) =
  event.control.canvas.textColor = rgb(255, 255, 255)
  event.control.canvas.drawText(calc_query, 32, 32)

control1.onDraw = proc (event: DrawEvent) =
  let canvas = event.control.canvas
  dgui.drawInterface(canvas)
  event.drawCalcQuery();

window.onResize = proc(wresize: ResizeEvent) =
  control1.onDraw = proc (event: DrawEvent) =
    let canvas = event.control.canvas
    dgui.drawInterface(canvas)
    event.drawCalcQuery();

control1.onMouseButtonDown = proc (mouse: MouseEvent) =
  control1.onDraw = proc (event: DrawEvent) =
    var f = dgui.fireInterface(event.control.canvas, mouse)
    if f != "btnEquals" and f != "null" and f != "btnClear":
      calc_query = calc_query & f[3]
    if f == "btnClear" and calc_query.len > 0:
      calc_query = calc_query[0..calc_query.len-2]
    if f == "btnEquals":
      echo evaluateMath(calc_query)
    event.drawCalcQuery();
  control1.forceRedraw()

control1.onMouseButtonUp = proc (mouse: MouseEvent) =
  control1.onDraw = proc (event: DrawEvent) =
    dgui.drawInterface(event.control.canvas)
    event.drawCalcQuery();
  control1.forceRedraw()

window.onKeyDown = proc(kb: KeyboardEvent) =
  # echo event.key
  # if event.key == Key_W:
  #   player.y = player.y - 1
  # if event.key == Key_A:
  #   player.x = player.x - 1
  # if event.key == Key_S:
  #   player.y = player.y + 1
  # if event.key == Key_D:
  #   player.x = player.x + 1
  # echo player.x
  control1.onDraw = proc (event: DrawEvent) =
    let canvas = event.control.canvas
    # canvas.areaColor = rgb(30, 30, 30) # dark grey
    # canvas.fill()
    # canvas.areaColor = rgb(255, 0, 0)
    # canvas.drawRectArea(player.x, player.y, 64, 64)
    dgui.inputInterface(canvas,kb)
  control1.forceRedraw()
# control1.onMouseButtonDown = proc (event: MouseEvent) =
#   echo(event.button, " (", event.x, ", ", event.y, ")")

window.show()
app.run()
