import nigui, osproc

app.init()
var window = newWindow()

window.width = 500
window.height = 500

var control1 = newControl()
window.add(control1)

control1.widthMode = WidthMode_Fill
control1.heightMode = HeightMode_Fill

# GPLный код Dev1lroot'a , спиздишь == сядишь)  {

type
  DevguiStyle = object
    d_fontSize: float
    d_color: Color
    d_background: Color
    h_fontSize: float
    h_color: Color
    h_background: Color

  DevguiButton = object
    text, id: string
    x, y, w, h: int
    style: DevguiStyle

  DevguiCheckbox = object
    text, id: string
    x, y, w, h, checked: int
    style: DevguiStyle

  DevguiInterface = object
    buttons: seq[DevguiButton]
    checkboxes: seq[DevguiCheckbox]

var player = DevguiButton(x:128,y:128,h:64,w:64)
var dgui: DevguiInterface

proc drawButton(canvas: Canvas, button: DevguiButton, state: int) =
  if(state > 0):
    canvas.areaColor = button.style.h_background
    canvas.textColor = button.style.h_color
    canvas.fontSize = button.style.h_fontSize
  else:
    canvas.areaColor = button.style.d_background
    canvas.textColor = button.style.d_color
    canvas.fontSize = button.style.d_fontSize
  canvas.drawRectArea(button.x, button.y, button.w, button.h)
  canvas.fontFamily = "Arial"
  canvas.drawTextCentered(button.text, button.x, button.y, button.w, button.h)

proc drawCheckbox(canvas: Canvas, checkbox: DevguiCheckbox, state: int) =
  if(state > 0):
    canvas.areaColor = checkbox.style.h_color
    canvas.textColor = checkbox.style.h_color
    canvas.fontSize = checkbox.style.h_fontSize
    canvas.lineColor = checkbox.style.h_color
    canvas.drawRectOutline(checkbox.x, checkbox.y, 19, 19)
    canvas.drawRectArea(checkbox.x+4, checkbox.y+4, 12, 12)
  else:
    canvas.areaColor = checkbox.style.d_background
    canvas.textColor = checkbox.style.d_color
    canvas.fontSize = checkbox.style.d_fontSize
    canvas.lineColor = checkbox.style.d_color
    canvas.drawRectOutline(checkbox.x, checkbox.y, 19, 19)
    canvas.drawRectArea(checkbox.x+4, checkbox.y+4, 12, 12)
  canvas.areaColor = rgb(30,30,30)
  canvas.drawRectArea(checkbox.x+20, checkbox.y, checkbox.w, checkbox.h)
  canvas.fontFamily = "Arial"
  canvas.drawText(checkbox.text, checkbox.x+24, checkbox.y)

proc checkboxSetState(d: var DevguiInterface, id: string, checked: int) =
  var n_checkboxes: seq[DevguiCheckbox]
  for checkbox in d.checkboxes:
    if checkbox.id == id:
      var n_out = checkbox
      n_out.checked = checked
      n_checkboxes.add(n_out)
    else:
      n_checkboxes.add(checkbox)
  d.checkboxes = n_checkboxes

proc removeButton(d: var DevguiInterface, id: string) =
  var n_b: seq[DevguiButton]
  for button in d.buttons:
    if button.id != id:
      n_b.add(button)
  d.buttons = n_b

proc checkboxGetState(d: var DevguiInterface, id: string): int =
  var o = 0
  for checkbox in d.checkboxes:
    if checkbox.id == id:
      o = checkbox.checked
      break
  return o

proc createButton(d: var DevguiInterface, id, text: string, x, y, w, h: int) =
  var defaultStyle = DevguiStyle(
    d_color: rgb(200, 200, 200), 
    h_color: rgb(255, 255, 255),
    d_fontSize: 13,
    h_fontSize: 13,
    d_background: rgb(64, 64, 64),  
    h_background: rgb(48, 48, 48))
  d.buttons.add(DevguiButton(text: text, id: id, x: x, y: y, w: w, h: h, style: defaultStyle))

proc createButton(d: var DevguiInterface, id, text: string, x, y, w, h: int, style: DevguiStyle) =
  d.buttons.add(DevguiButton(text: text, id: id, x: x, y: y, w: w, h: h, style: style))

proc createCheckbox(d: var DevguiInterface, id, text: string, x, y, w, h, checked: int) =
  var defaultStyle = DevguiStyle(
    d_color: rgb(200, 200, 200), 
    h_color: rgb(255, 255, 255),
    d_fontSize: 13,
    h_fontSize: 13,
    d_background: rgb(64, 64, 64),  
    h_background: rgb(48, 48, 48))
  d.checkboxes.add(DevguiCheckbox(text: text, id: id, x: x, y: y, w: w, h: h, checked: checked, style: defaultStyle))

proc drawInterface(d: var DevguiInterface, canvas: Canvas) =
  canvas.areaColor = rgb(30, 30, 30) # dark grey
  canvas.fill()
  for button in d.buttons:
    canvas.drawButton(button,0)
  for checkbox in d.checkboxes:
    canvas.drawCheckbox(checkbox,checkbox.checked)

proc fireInterface(d: var DevguiInterface, canvas: Canvas, mouse: MouseEvent): string =
  var fired = "null"
  canvas.areaColor = rgb(30, 30, 30) # dark grey
  canvas.fill()
  for checkbox in d.checkboxes:
    if(mouse.x >= checkbox.x and mouse.x <= checkbox.x+checkbox.w and mouse.y >= checkbox.y and mouse.y <= checkbox.y+checkbox.h):
      if checkbox.checked > 0:
        d.checkboxSetState(checkbox.id,0)
        canvas.drawCheckbox(checkbox,0)
      else:
        d.checkboxSetState(checkbox.id,1)
        canvas.drawCheckbox(checkbox,1)
      fired = checkbox.id
    else:
      canvas.drawCheckbox(checkbox,checkbox.checked)
  for button in d.buttons:
    if(mouse.x >= button.x and mouse.x <= button.x+button.w and mouse.y >= button.y and mouse.y <= button.y+button.h):
      canvas.drawButton(button,1)
      fired = button.id
    else:
      canvas.drawButton(button,0)
  return fired
  
#example controller usage

control1.onDraw = proc (event: DrawEvent) =
  let canvas = event.control.canvas
  dgui.drawInterface(canvas)

window.onResize = proc(wresize: ResizeEvent) =
  control1.onDraw = proc (event: DrawEvent) =
    let canvas = event.control.canvas
    dgui.drawInterface(canvas)

control1.onMouseButtonDown = proc (mouse: MouseEvent) =
  control1.onDraw = proc (event: DrawEvent) =
    var f = dgui.fireInterface(event.control.canvas, mouse)
    echo "fired button name: "&f
  control1.forceRedraw()

control1.onMouseButtonUp = proc (mouse: MouseEvent) =
  control1.onDraw = proc (event: DrawEvent) =
    dgui.drawInterface(event.control.canvas)
  control1.forceRedraw()
