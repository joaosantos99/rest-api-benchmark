package tests

import (
	"fmt"
	"math"
	"net/http"
)

const (
	PI            = math.Pi
	SOLAR_MASS    = 4 * PI * PI
	DAYS_PER_YEAR = 365.24
	STEPS         = 1000
)

type NBody struct {
	X, Y, Z float64
	VX, VY, VZ float64
	Mass float64
}

func Sun() NBody {
	return NBody{X: 0, Y: 0, Z: 0, VX: 0, VY: 0, VZ: 0, Mass: SOLAR_MASS}
}

func Jupiter() NBody {
	return NBody{
		X: 4.84143144246472090e+00,
		Y: -1.16032004402742839e+00,
		Z: -1.03622044471123109e-01,
		VX: 1.66007664274403694e-03 * DAYS_PER_YEAR,
		VY: 7.69901118419740425e-03 * DAYS_PER_YEAR,
		VZ: -6.90460016972063023e-05 * DAYS_PER_YEAR,
		Mass: 9.54791938424326609e-04 * SOLAR_MASS,
	}
}

func Saturn() NBody {
	return NBody{
		X: 8.34336671824457987e+00,
		Y: 4.12479856412430479e+00,
		Z: -4.03523417114321381e-01,
		VX: -2.76742510726862411e-03 * DAYS_PER_YEAR,
		VY: 4.99852801234917238e-03 * DAYS_PER_YEAR,
		VZ: 2.30417297573763929e-05 * DAYS_PER_YEAR,
		Mass: 2.85885980666130812e-04 * SOLAR_MASS,
	}
}

func Uranus() NBody {
	return NBody{
		X: 1.28943695621391310e+01,
		Y: -1.51111514016986312e+01,
		Z: -2.23307578892655734e-01,
		VX: 2.96460137564761618e-03 * DAYS_PER_YEAR,
		VY: 2.37847173959480950e-03 * DAYS_PER_YEAR,
		VZ: -2.96589568540237556e-05 * DAYS_PER_YEAR,
		Mass: 4.36624404335156298e-05 * SOLAR_MASS,
	}
}

func Neptune() NBody {
	return NBody{
		X: 1.53796971148509165e+01,
		Y: -2.59193146099879641e+01,
		Z: 1.79258772950371181e-01,
		VX: 2.68067772490389322e-03 * DAYS_PER_YEAR,
		VY: 1.62824170038242295e-03 * DAYS_PER_YEAR,
		VZ: -9.51592254519715870e-05 * DAYS_PER_YEAR,
		Mass: 5.15138902046611451e-05 * SOLAR_MASS,
	}
}

func offsetMomentum(bodies []NBody) {
	var px, py, pz float64
	for i := range bodies {
		b := &bodies[i]
		px += b.VX * b.Mass
		py += b.VY * b.Mass
		pz += b.VZ * b.Mass
	}

	sun := &bodies[0]
	sun.VX = -px / SOLAR_MASS
	sun.VY = -py / SOLAR_MASS
	sun.VZ = -pz / SOLAR_MASS
}

func advance(bodies []NBody, dt float64) {
	n := len(bodies)
	for i := 0; i < n; i++ {
		bi := &bodies[i]

		for j := i + 1; j < n; j++ {
			bj := &bodies[j]
			dx := bi.X - bj.X
			dy := bi.Y - bj.Y
			dz := bi.Z - bj.Z

			d2 := dx*dx + dy*dy + dz*dz
			mag := dt / (d2 * math.Sqrt(d2))

			bi.VX -= dx * bj.Mass * mag
			bi.VY -= dy * bj.Mass * mag
			bi.VZ -= dz * bj.Mass * mag

			bj.VX += dx * bi.Mass * mag
			bj.VY += dy * bi.Mass * mag
			bj.VZ += dz * bi.Mass * mag
		}
	}

	for i := 0; i < n; i++ {
		b := &bodies[i]
		b.X += dt * b.VX
		b.Y += dt * b.VY
		b.Z += dt * b.VZ
	}
}

func energy(bodies []NBody) float64 {
	var e float64
	n := len(bodies)
	for i := 0; i < n; i++ {
		bi := &bodies[i]
		e += 0.5 * bi.Mass * (bi.VX*bi.VX + bi.VY*bi.VY + bi.VZ*bi.VZ)
		for j := i + 1; j < n; j++ {
			bj := &bodies[j]
			dx := bi.X - bj.X
			dy := bi.Y - bj.Y
			dz := bi.Z - bj.Z
			dist := math.Sqrt(dx*dx + dy*dy + dz*dz)
			e -= (bi.Mass * bj.Mass) / dist
		}
	}
	return e
}

func NBodyHandler(w http.ResponseWriter, r *http.Request) {
	bodies := []NBody{
		Sun(),
		Jupiter(),
		Saturn(),
		Uranus(),
		Neptune(),
	}
	offsetMomentum(bodies)

	initial := energy(bodies)
	for i := 0; i < STEPS; i++ {
		advance(bodies, 0.01)
	}
	final := energy(bodies)

	fmt.Fprintf(w, "%.9f\n%.9f\n", initial, final)
}
