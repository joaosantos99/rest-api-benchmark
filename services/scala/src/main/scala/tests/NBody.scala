package tests

import scala.math.{Pi, sqrt}

object NBody {
  val PI = Pi
  val SOLAR_MASS = 4 * PI * PI
  val DAYS_PER_YEAR = 365.24
  val STEPS = 1000

  case class Body(
    x: Double, y: Double, z: Double,
    vx: Double, vy: Double, vz: Double,
    mass: Double
  )

  def jupiter(): Body = Body(
    x = 4.84143144246472090e+00,
    y = -1.16032004402742839e+00,
    z = -1.03622044471123109e-01,
    vx = 1.66007664274403694e-03 * DAYS_PER_YEAR,
    vy = 7.69901118419740425e-03 * DAYS_PER_YEAR,
    vz = -6.90460016972063023e-05 * DAYS_PER_YEAR,
    mass = 9.54791938424326609e-04 * SOLAR_MASS
  )

  def saturn(): Body = Body(
    x = 8.34336671824457987e+00,
    y = 4.12479856412430479e+00,
    z = -4.03523417114321381e-01,
    vx = -2.76742510726862411e-03 * DAYS_PER_YEAR,
    vy = 4.99852801234917238e-03 * DAYS_PER_YEAR,
    vz = 2.30417297573763929e-05 * DAYS_PER_YEAR,
    mass = 2.85885980666130812e-04 * SOLAR_MASS
  )

  def uranus(): Body = Body(
    x = 1.28943695621391310e+01,
    y = -1.51111514016986312e+01,
    z = -2.23307578892655734e-01,
    vx = 2.96460137564761618e-03 * DAYS_PER_YEAR,
    vy = 2.37847173959480950e-03 * DAYS_PER_YEAR,
    vz = -2.96589568540237556e-05 * DAYS_PER_YEAR,
    mass = 4.36624404335156298e-05 * SOLAR_MASS
  )

  def neptune(): Body = Body(
    x = 1.53796971148509165e+01,
    y = -2.59193146099879641e+01,
    z = 1.79258772950371181e-01,
    vx = 2.68067772490389322e-03 * DAYS_PER_YEAR,
    vy = 1.62824170038242295e-03 * DAYS_PER_YEAR,
    vz = -9.51592254519715870e-05 * DAYS_PER_YEAR,
    mass = 5.15138902046611451e-05 * SOLAR_MASS
  )

  def sun(): Body = Body(
    x = 0, y = 0, z = 0,
    vx = 0, vy = 0, vz = 0,
    mass = SOLAR_MASS
  )

  def offsetMomentum(bodies: Array[Body]): Unit = {
    var px = 0.0
    var py = 0.0
    var pz = 0.0

    for (body <- bodies) {
      px += body.vx * body.mass
      py += body.vy * body.mass
      pz += body.vz * body.mass
    }

    val sun = bodies(0)
    bodies(0) = sun.copy(
      vx = -px / SOLAR_MASS,
      vy = -py / SOLAR_MASS,
      vz = -pz / SOLAR_MASS
    )
  }

  def advance(bodies: Array[Body], dt: Double): Unit = {
    val n = bodies.length
    for (i <- 0 until n) {
      val bi = bodies(i)
      var vxi = bi.vx
      var vyi = bi.vy
      var vzi = bi.vz

      for (j <- i + 1 until n) {
        val bj = bodies(j)
        val dx = bi.x - bj.x
        val dy = bi.y - bj.y
        val dz = bi.z - bj.z
        val d2 = dx * dx + dy * dy + dz * dz
        val mag = dt / (d2 * sqrt(d2))

        vxi -= dx * bj.mass * mag
        vyi -= dy * bj.mass * mag
        vzi -= dz * bj.mass * mag

        bodies(j) = bj.copy(
          vx = bj.vx + dx * bi.mass * mag,
          vy = bj.vy + dy * bi.mass * mag,
          vz = bj.vz + dz * bi.mass * mag
        )
      }

      bodies(i) = bi.copy(
        vx = vxi,
        vy = vyi,
        vz = vzi,
        x = bi.x + dt * vxi,
        y = bi.y + dt * vyi,
        z = bi.z + dt * vzi
      )
    }
  }

  def energy(bodies: Array[Body]): Double = {
    var e = 0.0
    val n = bodies.length

    for (i <- 0 until n) {
      val bi = bodies(i)
      e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz)

      for (j <- i + 1 until n) {
        val bj = bodies(j)
        val dx = bi.x - bj.x
        val dy = bi.y - bj.y
        val dz = bi.z - bj.z
        val dist = sqrt(dx * dx + dy * dy + dz * dz)
        e -= (bi.mass * bj.mass) / dist
      }
    }

    e
  }

  def nBody(): String = {
    // Build a fresh system per request (no shared mutable state)
    val bodies = Array(sun(), jupiter(), saturn(), uranus(), neptune())
    offsetMomentum(bodies)

    val initial = f"${energy(bodies)}%.9f"

    for (_ <- 0 until STEPS) {
      advance(bodies, 0.01)
    }

    val finalEnergy = f"${energy(bodies)}%.9f"

    s"$initial\n$finalEnergy\n"
  }
}
