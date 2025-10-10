use axum::response::Response;

const PI: f64 = std::f64::consts::PI;
const SOLAR_MASS: f64 = 4.0 * PI * PI;
const DAYS_PER_YEAR: f64 = 365.24;
const STEPS: usize = 1000;

#[derive(Clone)]
struct NBody {
    x: f64,
    y: f64,
    z: f64,
    vx: f64,
    vy: f64,
    vz: f64,
    mass: f64,
}

impl NBody {
    fn sun() -> Self {
        Self {
            x: 0.0,
            y: 0.0,
            z: 0.0,
            vx: 0.0,
            vy: 0.0,
            vz: 0.0,
            mass: SOLAR_MASS,
        }
    }

    fn jupiter() -> Self {
        Self {
            x: 4.84143144246472090e+00,
            y: -1.16032004402742839e+00,
            z: -1.03622044471123109e-01,
            vx: 1.66007664274403694e-03 * DAYS_PER_YEAR,
            vy: 7.69901118419740425e-03 * DAYS_PER_YEAR,
            vz: -6.90460016972063023e-05 * DAYS_PER_YEAR,
            mass: 9.54791938424326609e-04 * SOLAR_MASS,
        }
    }

    fn saturn() -> Self {
        Self {
            x: 8.34336671824457987e+00,
            y: 4.12479856412430479e+00,
            z: -4.03523417114321381e-01,
            vx: -2.76742510726862411e-03 * DAYS_PER_YEAR,
            vy: 4.99852801234917238e-03 * DAYS_PER_YEAR,
            vz: 2.30417297573763929e-05 * DAYS_PER_YEAR,
            mass: 2.85885980666130812e-04 * SOLAR_MASS,
        }
    }

    fn uranus() -> Self {
        Self {
            x: 1.28943695621391310e+01,
            y: -1.51111514016986312e+01,
            z: -2.23307578892655734e-01,
            vx: 2.96460137564761618e-03 * DAYS_PER_YEAR,
            vy: 2.37847173959480950e-03 * DAYS_PER_YEAR,
            vz: -2.96589568540237556e-05 * DAYS_PER_YEAR,
            mass: 4.36624404335156298e-05 * SOLAR_MASS,
        }
    }

    fn neptune() -> Self {
        Self {
            x: 1.53796971148509165e+01,
            y: -2.59193146099879641e+01,
            z: 1.79258772950371181e-01,
            vx: 2.68067772490389322e-03 * DAYS_PER_YEAR,
            vy: 1.62824170038242295e-03 * DAYS_PER_YEAR,
            vz: -9.51592254519715870e-05 * DAYS_PER_YEAR,
            mass: 5.15138902046611451e-05 * SOLAR_MASS,
        }
    }
}

fn offset_momentum(bodies: &mut [NBody]) {
    let mut px = 0.0;
    let mut py = 0.0;
    let mut pz = 0.0;

    for body in bodies.iter() {
        px += body.vx * body.mass;
        py += body.vy * body.mass;
        pz += body.vz * body.mass;
    }

    let sun = &mut bodies[0];
    sun.vx = -px / SOLAR_MASS;
    sun.vy = -py / SOLAR_MASS;
    sun.vz = -pz / SOLAR_MASS;
}

fn advance(bodies: &mut [NBody], dt: f64) {
    let n = bodies.len();

    // Calculate velocity changes
    for i in 0..n {
        let mut vxi = bodies[i].vx;
        let mut vyi = bodies[i].vy;
        let mut vzi = bodies[i].vz;

        for j in (i + 1)..n {
            let dx = bodies[i].x - bodies[j].x;
            let dy = bodies[i].y - bodies[j].y;
            let dz = bodies[i].z - bodies[j].z;
            let d2 = dx * dx + dy * dy + dz * dz;
            let mag = dt / (d2 * d2.sqrt());

            vxi -= dx * bodies[j].mass * mag;
            vyi -= dy * bodies[j].mass * mag;
            vzi -= dz * bodies[j].mass * mag;

            bodies[j].vx += dx * bodies[i].mass * mag;
            bodies[j].vy += dy * bodies[i].mass * mag;
            bodies[j].vz += dz * bodies[i].mass * mag;
        }

        bodies[i].vx = vxi;
        bodies[i].vy = vyi;
        bodies[i].vz = vzi;
    }

    // Update positions
    for body in bodies.iter_mut() {
        body.x += dt * body.vx;
        body.y += dt * body.vy;
        body.z += dt * body.vz;
    }
}

fn energy(bodies: &[NBody]) -> f64 {
    let mut e = 0.0;
    let n = bodies.len();

    for i in 0..n {
        let bi = &bodies[i];
        e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);

        for j in (i + 1)..n {
            let bj = &bodies[j];
            let dx = bi.x - bj.x;
            let dy = bi.y - bj.y;
            let dz = bi.z - bj.z;
            let dist = (dx * dx + dy * dy + dz * dz).sqrt();
            e -= (bi.mass * bj.mass) / dist;
        }
    }

    e
}

pub async fn handler() -> Response<String> {
    let mut bodies = vec![
        NBody::sun(),
        NBody::jupiter(),
        NBody::saturn(),
        NBody::uranus(),
        NBody::neptune(),
    ];

    offset_momentum(&mut bodies);

    let initial = energy(&bodies);
    for _ in 0..STEPS {
        advance(&mut bodies, 0.01);
    }
    let final_energy = energy(&bodies);

    let result = format!("{:.9}\n{:.9}\n", initial, final_energy);
    Response::new(result)
}
