using Microsoft.AspNetCore.Mvc;

namespace CSharpBenchmark.Controllers;

[ApiController]
[Route("api")]
public class NBodyController : ControllerBase
{
    private const double Pi = Math.PI;
    private const double SolarMass = 4.0 * Pi * Pi;
    private const double DaysPerYear = 365.24;
    private const int Steps = 1000;

    public class NBody
    {
        public double X { get; set; }
        public double Y { get; set; }
        public double Z { get; set; }
        public double Vx { get; set; }
        public double Vy { get; set; }
        public double Vz { get; set; }
        public double Mass { get; set; }

        public static NBody Sun() => new()
        {
            X = 0.0,
            Y = 0.0,
            Z = 0.0,
            Vx = 0.0,
            Vy = 0.0,
            Vz = 0.0,
            Mass = SolarMass
        };

        public static NBody Jupiter() => new()
        {
            X = 4.84143144246472090e+00,
            Y = -1.16032004402742839e+00,
            Z = -1.03622044471123109e-01,
            Vx = 1.66007664274403694e-03 * DaysPerYear,
            Vy = 7.69901118419740425e-03 * DaysPerYear,
            Vz = -6.90460016972063023e-05 * DaysPerYear,
            Mass = 9.54791938424326609e-04 * SolarMass
        };

        public static NBody Saturn() => new()
        {
            X = 8.34336671824457987e+00,
            Y = 4.12479856412430479e+00,
            Z = -4.03523417114321381e-01,
            Vx = -2.76742510726862411e-03 * DaysPerYear,
            Vy = 4.99852801234917238e-03 * DaysPerYear,
            Vz = 2.30417297573763929e-05 * DaysPerYear,
            Mass = 2.85885980666130812e-04 * SolarMass
        };

        public static NBody Uranus() => new()
        {
            X = 1.28943695621391310e+01,
            Y = -1.51111514016986312e+01,
            Z = -2.23307578892655734e-01,
            Vx = 2.96460137564761618e-03 * DaysPerYear,
            Vy = 2.37847173959480950e-03 * DaysPerYear,
            Vz = -2.96589568540237556e-05 * DaysPerYear,
            Mass = 4.36624404335156298e-05 * SolarMass
        };

        public static NBody Neptune() => new()
        {
            X = 1.53796971148509165e+01,
            Y = -2.59193146099879641e+01,
            Z = 1.79258772950371181e-01,
            Vx = 2.68067772490389322e-03 * DaysPerYear,
            Vy = 1.62824170038242295e-03 * DaysPerYear,
            Vz = -9.51592254519715870e-05 * DaysPerYear,
            Mass = 5.15138902046611451e-05 * SolarMass
        };
    }

    [HttpGet("n-body")]
    public IActionResult GetNBody()
    {
        var bodies = new List<NBody>
        {
            NBody.Sun(),
            NBody.Jupiter(),
            NBody.Saturn(),
            NBody.Uranus(),
            NBody.Neptune()
        };

        OffsetMomentum(bodies);

        var initial = Energy(bodies);
        for (int i = 0; i < Steps; i++)
        {
            Advance(bodies, 0.01);
        }
        var finalEnergy = Energy(bodies);

        var result = $"{initial:F9}\n{finalEnergy:F9}\n";
        return Ok(result);
    }

    private static void OffsetMomentum(List<NBody> bodies)
    {
        double px = 0.0, py = 0.0, pz = 0.0;

        foreach (var body in bodies)
        {
            px += body.Vx * body.Mass;
            py += body.Vy * body.Mass;
            pz += body.Vz * body.Mass;
        }

        var sun = bodies[0];
        sun.Vx = -px / SolarMass;
        sun.Vy = -py / SolarMass;
        sun.Vz = -pz / SolarMass;
    }

    private static void Advance(List<NBody> bodies, double dt)
    {
        int n = bodies.Count;

        // Calculate velocity changes
        for (int i = 0; i < n; i++)
        {
            double vxi = bodies[i].Vx;
            double vyi = bodies[i].Vy;
            double vzi = bodies[i].Vz;

            for (int j = i + 1; j < n; j++)
            {
                double dx = bodies[i].X - bodies[j].X;
                double dy = bodies[i].Y - bodies[j].Y;
                double dz = bodies[i].Z - bodies[j].Z;
                double d2 = dx * dx + dy * dy + dz * dz;
                double mag = dt / (d2 * Math.Sqrt(d2));

                vxi -= dx * bodies[j].Mass * mag;
                vyi -= dy * bodies[j].Mass * mag;
                vzi -= dz * bodies[j].Mass * mag;

                bodies[j].Vx += dx * bodies[i].Mass * mag;
                bodies[j].Vy += dy * bodies[i].Mass * mag;
                bodies[j].Vz += dz * bodies[i].Mass * mag;
            }

            bodies[i].Vx = vxi;
            bodies[i].Vy = vyi;
            bodies[i].Vz = vzi;
        }

        // Update positions
        foreach (var body in bodies)
        {
            body.X += dt * body.Vx;
            body.Y += dt * body.Vy;
            body.Z += dt * body.Vz;
        }
    }

    private static double Energy(List<NBody> bodies)
    {
        double e = 0.0;
        int n = bodies.Count;

        for (int i = 0; i < n; i++)
        {
            var bi = bodies[i];
            e += 0.5 * bi.Mass * (bi.Vx * bi.Vx + bi.Vy * bi.Vy + bi.Vz * bi.Vz);

            for (int j = i + 1; j < n; j++)
            {
                var bj = bodies[j];
                double dx = bi.X - bj.X;
                double dy = bi.Y - bj.Y;
                double dz = bi.Z - bj.Z;
                double dist = Math.Sqrt(dx * dx + dy * dy + dz * dz);
                e -= (bi.Mass * bj.Mass) / dist;
            }
        }

        return e;
    }
}
