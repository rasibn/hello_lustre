import gleam/int
import lustre as l
import lustre/element as el
import lustre/element/html as h
import lustre/event as e

// import lustre/attribute as a

pub type Model =
  Int

fn init(_flags) -> Model {
  0
}

pub type Msg {
  Increment
  Decrement
}

pub fn update(model: Model, msg: Msg) -> Model {
  case msg {
    Increment -> model + 1
    Decrement -> model - 1
  }
}

pub fn view(model: Model) -> el.Element(Msg) {
  let count = int.to_string(model)
  h.div([], [
    h.button([e.on_click(Increment)], [el.text("+")]),
    el.text(count),
    h.button([e.on_click(Decrement)], [el.text("-")]),
  ])
}

pub fn main() {
  let app = l.simple(init, update, view)
  let assert Ok(_) = l.start(app, "#app", Nil)
}
