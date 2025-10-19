package com.benchmark.tests;

import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import java.io.IOException;
import java.io.OutputStream;

public class NBody implements HttpHandler {
    private static final double PI = Math.PI;
    private static final double SOLAR_MASS = 4.0 * PI * PI;
    private static final double DAYS_PER_YEAR = 365.24;
    private static final int STEPS = 1000;

    static class Body {
        double x, y, z, vx, vy, vz, mass;

        Body(double x, double y, double z, double vx, double vy, double vz, double mass) {
            this.x = x;
            this.y = y;
            this.z = z;
            this.vx = vx;
            this.vy = vy;
            this.vz = vz;
            this.mass = mass;
        }

        static Body sun() {
            return new Body(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, SOLAR_MASS);
        }

        static Body jupiter() {
            return new Body(
                4.84143144246472090e+00,
                -1.16032004402742839e+00,
                -1.03622044471123109e-01,
                1.66007664274403694e-03 * DAYS_PER_YEAR,
                7.69901118419740425e-03 * DAYS_PER_YEAR,
                -6.90460016972063023e-05 * DAYS_PER_YEAR,
                9.54791938424326609e-04 * SOLAR_MASS
            );
        }

        static Body saturn() {
            return new Body(
                8.34336671824457987e+00,
                4.12479856412430479e+00,
                -4.03523417114321381e-01,
                -2.76742510726862411e-03 * DAYS_PER_YEAR,
                4.99852801234917238e-03 * DAYS_PER_YEAR,
                2.30417297573763929e-05 * DAYS_PER_YEAR,
                2.85885980666130812e-04 * SOLAR_MASS
            );
        }

        static Body uranus() {
            return new Body(
                1.28943695621391310e+01,
                -1.51111514016986312e+01,
                -2.23307578892655734e-01,
                2.96460137564761618e-03 * DAYS_PER_YEAR,
                2.37847173959480950e-03 * DAYS_PER_YEAR,
                -2.96589568540237556e-05 * DAYS_PER_YEAR,
                4.36624404335156298e-05 * SOLAR_MASS
            );
        }

        static Body neptune() {
            return new Body(
                1.53796971148509165e+01,
                -2.59193146099879641e+01,
                1.79258772950371181e-01,
                2.68067772490389322e-03 * DAYS_PER_YEAR,
                1.62824170038242295e-03 * DAYS_PER_YEAR,
                -9.51592254519715870e-05 * DAYS_PER_YEAR,
                5.15138902046611451e-05 * SOLAR_MASS
            );
        }
    }

    private static void offsetMomentum(Body[] bodies) {
        double px = 0.0, py = 0.0, pz = 0.0;
        for (Body body : bodies) {
            px += body.vx * body.mass;
            py += body.vy * body.mass;
            pz += body.vz * body.mass;
        }
        bodies[0].vx = -px / SOLAR_MASS;
        bodies[0].vy = -py / SOLAR_MASS;
        bodies[0].vz = -pz / SOLAR_MASS;
    }

    private static void advance(Body[] bodies, double dt) {
        int n = bodies.length;
        for (int i = 0; i < n; i++) {
            double vxi = bodies[i].vx;
            double vyi = bodies[i].vy;
            double vzi = bodies[i].vz;
            for (int j = i + 1; j < n; j++) {
                double dx = bodies[i].x - bodies[j].x;
                double dy = bodies[i].y - bodies[j].y;
                double dz = bodies[i].z - bodies[j].z;
                double d2 = dx * dx + dy * dy + dz * dz;
                double mag = dt / (d2 * Math.sqrt(d2));
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
        for (Body body : bodies) {
            body.x += dt * body.vx;
            body.y += dt * body.vy;
            body.z += dt * body.vz;
        }
    }

    private static double energy(Body[] bodies) {
        double e = 0.0;
        int n = bodies.length;
        for (int i = 0; i < n; i++) {
            Body bi = bodies[i];
            e += 0.5 * bi.mass * (bi.vx * bi.vx + bi.vy * bi.vy + bi.vz * bi.vz);
            for (int j = i + 1; j < n; j++) {
                Body bj = bodies[j];
                double dx = bi.x - bj.x;
                double dy = bi.y - bj.y;
                double dz = bi.z - bj.z;
                double dist = Math.sqrt(dx * dx + dy * dy + dz * dz);
                e -= (bi.mass * bj.mass) / dist;
            }
        }
        return e;
    }

    @Override
    public void handle(HttpExchange exchange) throws IOException {
        Body[] bodies = {
            Body.sun(),
            Body.jupiter(),
            Body.saturn(),
            Body.uranus(),
            Body.neptune()
        };

        offsetMomentum(bodies);
        double initial = energy(bodies);
        for (int i = 0; i < STEPS; i++) {
            advance(bodies, 0.01);
        }
        double finalEnergy = energy(bodies);

        String response = String.format("%.9f%n%.9f%n", initial, finalEnergy);
        exchange.getResponseHeaders().set("Content-Type", "text/plain");
        exchange.sendResponseHeaders(200, response.length());
        OutputStream os = exchange.getResponseBody();
        os.write(response.getBytes());
        os.close();
    }
}
