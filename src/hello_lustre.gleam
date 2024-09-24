import gleam/dynamic
import gleam/int
import gleam/list
import lustre as l
import lustre/attribute as a
import lustre/effect
import lustre/element as el
import lustre/element/html as h
import lustre/event as e
import lustre_http

// A model produces a view
pub type Model {
  Model(count: Int, cats: List(String))
}

// The view can produce messages in response to user interaction
fn init(_flags) -> #(Model, effect.Effect(Msg)) {
  #(Model(0, []), effect.none())
}

// The possible messages
pub type Msg {
  UserIncrementedCount
  UserDecrementedCount
  ApiReturnedCat(Result(String, lustre_http.HttpError))
}

// Those messages are passed to the update function to produce a new model
pub fn update(model: Model, msg: Msg) {
  case msg {
    UserIncrementedCount -> #(Model(..model, count: model.count + 1), get_cat())
    UserDecrementedCount -> #(
      Model(..model, count: model.count - 1),
      effect.none(),
    )
    ApiReturnedCat(Ok(cat)) -> #(
      Model(..model, cats: [cat, ..model.cats]),
      effect.none(),
    )
    ApiReturnedCat(Error(_)) -> #(model, effect.none())
  }
}

fn get_cat() {
  let decoder = dynamic.field("_id", dynamic.string)
  let expect = lustre_http.expect_json(decoder, ApiReturnedCat)
  lustre_http.get("https://cataas.com/cat?json=true", expect)
}

// The view can produce messages in response to user interaction
pub fn view(model: Model) -> el.Element(Msg) {
  h.div([], [
    h.button([e.on_click(UserIncrementedCount)], [el.text("+")]),
    el.text(model.count |> int.to_string),
    h.button([e.on_click(UserDecrementedCount)], [el.text("-")]),
    h.div(
      [],
      list.map(model.cats, fn(cat) {
        h.img([a.src("https://cataas.com/cat/" <> cat)])
      }),
    ),
  ])
}

pub fn main() {
  let app = l.application(init, update, view)
  let assert Ok(_) = l.start(app, "#app", Nil)

  Nil
}
