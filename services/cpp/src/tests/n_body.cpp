#include "n_body.h"
#include <vector>
#include <cmath>
#include <sstream>
#include <iomanip>

const double PI = 3.14159265358979323846;
const double SOLAR_MASS = 4.0 * PI * PI;
const double DAYS_PER_YEAR = 365.24;
const int STEPS = 1000;

struct NBody {
    double x, y, z;
    double vx, vy, vz;
    double mass;

    NBody(double x, double y, double z, double vx, double vy, double vz, double mass)
        : x(x), y(y), z(z), vx(vx), vy(vy), vz(vz), mass(mass) {}
};

NBody sun() {
    return NBody(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS);
}

NBody jupiter() {
    return NBody(
        4.84143144246472090e+00,
        -1.16032004402742839e+00,
        -1.03622044471123109e-01,
        1.66007664274403694e-03 * DAYS_PER_YEAR,
        7.69901118419740425e-03 * DAYS_PER_YEAR,
        -6.90460016972063023e-05 * DAYS_PER_YEAR,
        9.54791938424326609e-04 * SOLAR_MASS
    );
}

NBody saturn() {
    return NBody(
        8.34336671824457987e+00,
        4.12479856412430479e+00,
        -4.03523417114321381e-01,
        -2.76742510726862411e-03 * DAYS_PER_YEAR,
        4.99852801234917238e-03 * DAYS_PER_YEAR,
        2.30417297573763929e-05 * DAYS_PER_YEAR,
        2.85885980666130812e-04 * SOLAR_MASS
    );
}

NBody uranus() {
    return NBody(
        1.28943695621391310e+01,
        -1.51111514016986312e+01,
        -2.23307578892655734e-01,
        2.96460137564761618e-03 * DAYS_PER_YEAR,
        2.37847173959480950e-03 * DAYS_PER_YEAR,
        -2.96589568540237556e-05 * DAYS_PER_YEAR,
        4.36624404335156298e-05 * SOLAR_MASS
    );
}

NBody neptune() {
    return NBody(
        1.53796971148509165e+01,
        -2.59193146099879641e+01,
        1.79258772950371181e-01,
        2.68067772490389322e-03 * DAYS_PER_YEAR,
        1.62824170038242295e-03 * DAYS_PER_YEAR,
        -9.51592254519715870e-05 * DAYS_PER_YEAR,
        5.15138902046611451e-05 * SOLAR_MASS
    );
}

void offset_momentum(std::vector<NBody>& bodies) {
    double px = 0.0, py = 0.0, pz = 0.0;

    for (const auto& body : bodies) {
        px += body.vx * body.mass;
        py += body.vy * body.mass;
        pz += body.vz * body.mass;
    }

    bodies[0].vx = -px / SOLAR_MASS;
    bodies[0].vy = -py / SOLAR_MASS;
    bodies[0].vz = -pz / SOLAR_MASS;
}

void advance(std::vector<NBody>& bodies, double dt) {
    int n = bodies.size();

    // Calculate velocity changes
    for (int i = 0; i < n; i++) {
        double vxi = bodies[i].vx;
        double vyi = bodies[i].vy;
        double vzi = bodies[i].vz;

        for (int j = i + 1; j < n; j++) {
            double dx = bodies[i].x - bodies[j].x;
            double dy = bodies[i].y - bodies[j].y;
            double dz = bodies[i].z - bodies[j].z;
            double d2 = dx * dx + dy * dy + dz * dz;
            double mag = dt / (d2 * std::sqrt(d2));

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
    for (auto& body : bodies) {
        body.x += dt * body.vx;
        body.y += dt * body.vy;
        body.z += dt * body.vz;
    }
}

double energy(const std::vector<NBody>& bodies) {
    double e = 0.0;
    int n = bodies.size();

    for (int i = 0; i < n; i++) {
        const auto& bi = bodies[i];
        e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);

        for (int j = i + 1; j < n; j++) {
            const auto& bj = bodies[j];
            double dx = bi.x - bj.x;
            double dy = bi.y - bj.y;
            double dz = bi.z - bj.z;
            double dist = std::sqrt(dx * dx + dy * dy + dz * dz);
            e -= (bi.mass * bj.mass) / dist;
        }
    }

    return e;
}

crow::response n_body() {
    std::vector<NBody> bodies = {
        sun(),
        jupiter(),
        saturn(),
        uranus(),
        neptune()
    };

    offset_momentum(bodies);

    double initial = energy(bodies);
    for (int i = 0; i < STEPS; i++) {
        advance(bodies, 0.01);
    }
    double final_energy = energy(bodies);

    std::ostringstream oss;
    oss << std::fixed << std::setprecision(9)
        << initial << "\n"
        << final_energy << "\n";

    return crow::response(200, oss.str());
}
