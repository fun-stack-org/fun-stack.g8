package example.webapp

import cats.effect.IO
import example.api.{HttpRpcApi, WebsocketApi, WebsocketEventApi}
import colibri.Observable
import sloth.Client
import funstack.web.Fun

import chameleon.ext.circe._

object WsClient {
  val client                = Client(Fun.ws.transport[String])
  val api: WebsocketApi[IO] = client.wire[WebsocketApi[IO]]

  val eventClient                             = Client(Fun.ws.streamsTransport[String])
  val eventApi: WebsocketEventApi[Observable] = eventClient.wire[WebsocketEventApi[Observable]]
}

object HttpClient {
  val client              = Client(Fun.http.transport[String])
  val api: HttpRpcApi[IO] = client.wire[HttpRpcApi[IO]]
}
