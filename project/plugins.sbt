addSbtPlugin("org.scala-js"  % "sbt-scalajs"         % "1.18.1")
addSbtPlugin("ch.epfl.scala" % "sbt-scalajs-bundler" % "0.21.1")

addSbtPlugin("org.scalablytyped.converter" % "sbt-converter" % "1.0.0-beta44")

addSbtPlugin("org.typelevel" % "sbt-tpolecat" % "0.5.2")
addSbtPlugin("org.scalameta" % "sbt-scalafmt" % "2.5.4")

// for reading npmDependencies from package.json
libraryDependencies ++= Seq("com.lihaoyi" %% "upickle" % "2.0.0")
