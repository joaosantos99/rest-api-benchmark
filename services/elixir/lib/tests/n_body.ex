defmodule ElixirBenchmark.Tests.NBody do
  @moduledoc false

  @pi :math.pi()
  @solar_mass 4.0 * @pi * @pi
  @days_per_year 365.24
  @steps 1000

  defstruct [:x, :y, :z, :vx, :vy, :vz, :mass]

  def handler do
    bodies = [
      sun(),
      jupiter(),
      saturn(),
      uranus(),
      neptune()
    ]

    bodies_with_momentum = offset_momentum(bodies)
    initial_energy = energy(bodies_with_momentum)

    final_bodies = advance(bodies_with_momentum, @steps, 0.01)
    final_energy = energy(final_bodies)

    "#{Float.to_string(initial_energy, decimals: 9)}\n#{Float.to_string(final_energy, decimals: 9)}\n"
  end

  defp sun do
    %__MODULE__{
      x: 0.0,
      y: 0.0,
      z: 0.0,
      vx: 0.0,
      vy: 0.0,
      vz: 0.0,
      mass: @solar_mass
    }
  end

  defp jupiter do
    %__MODULE__{
      x: 4.84143144246472090e+00,
      y: -1.16032004402742839e+00,
      z: -1.03622044471123109e-01,
      vx: 1.66007664274403694e-03 * @days_per_year,
      vy: 7.69901118419740425e-03 * @days_per_year,
      vz: -6.90460016972063023e-05 * @days_per_year,
      mass: 9.54791938424326609e-04 * @solar_mass
    }
  end

  defp saturn do
    %__MODULE__{
      x: 8.34336671824457987e+00,
      y: 4.12479856412430479e+00,
      z: -4.03523417114321381e-01,
      vx: -2.76742510726862411e-03 * @days_per_year,
      vy: 4.99852801234917238e-03 * @days_per_year,
      vz: 2.30417297573763929e-05 * @days_per_year,
      mass: 2.85885980666130812e-04 * @solar_mass
    }
  end

  defp uranus do
    %__MODULE__{
      x: 1.28943695621391310e+01,
      y: -1.51111514016986312e+01,
      z: -2.23307578892655734e-01,
      vx: 2.96460137564761618e-03 * @days_per_year,
      vy: 2.37847173959480950e-03 * @days_per_year,
      vz: -2.96589568540237556e-05 * @days_per_year,
      mass: 4.36624404335156298e-05 * @solar_mass
    }
  end

  defp neptune do
    %__MODULE__{
      x: 1.53796971148509165e+01,
      y: -2.59193146099879641e+01,
      z: 1.79258772950371181e-01,
      vx: 2.68067772490389322e-03 * @days_per_year,
      vy: 1.62824170038242295e-03 * @days_per_year,
      vz: -9.51592254519715870e-05 * @days_per_year,
      mass: 5.15138902046611451e-05 * @solar_mass
    }
  end

  defp offset_momentum(bodies) do
    {px, py, pz} =
      Enum.reduce(bodies, {0.0, 0.0, 0.0}, fn body, {px, py, pz} ->
        {px + body.vx * body.mass, py + body.vy * body.mass, pz + body.vz * body.mass}
      end)

    [sun | rest] = bodies
    sun = %{sun | vx: -px / @solar_mass, vy: -py / @solar_mass, vz: -pz / @solar_mass}
    [sun | rest]
  end

  defp advance(bodies, 0, _dt), do: bodies
  defp advance(bodies, steps, dt) do
    bodies_with_velocity = calculate_velocity_changes(bodies, dt)
    bodies_with_position = update_positions(bodies_with_velocity, dt)
    advance(bodies_with_position, steps - 1, dt)
  end

  defp calculate_velocity_changes(bodies, dt) do
    bodies
    |> Enum.with_index()
    |> Enum.map(fn {body, i} ->
      {vx, vy, vz} =
        Enum.reduce(Enum.with_index(bodies), {body.vx, body.vy, body.vz}, fn {other_body, j}, {vx, vy, vz} ->
          if j > i do
            dx = body.x - other_body.x
            dy = body.y - other_body.y
            dz = body.z - other_body.z
            d2 = dx * dx + dy * dy + dz * dz
            mag = dt / (d2 * :math.sqrt(d2))

            {vx - dx * other_body.mass * mag, vy - dy * other_body.mass * mag, vz - dz * other_body.mass * mag}
          else
            {vx, vy, vz}
          end
        end)

      %{body | vx: vx, vy: vy, vz: vz}
    end)
  end

  defp update_positions(bodies, dt) do
    Enum.map(bodies, fn body ->
      %{body |
        x: body.x + dt * body.vx,
        y: body.y + dt * body.vy,
        z: body.z + dt * body.vz
      }
    end)
  end

  defp energy(bodies) do
    {kinetic, potential} =
      bodies
      |> Enum.with_index()
      |> Enum.reduce({0.0, 0.0}, fn {body, i}, {kinetic, potential} ->
        kinetic_energy = 0.5 * body.mass * (body.vx * body.vx + body.vy * body.vy + body.vz * body.vz)

        potential_energy =
          bodies
          |> Enum.with_index()
          |> Enum.filter(fn {_, j} -> j > i end)
          |> Enum.reduce(0.0, fn {other_body, _}, acc ->
            dx = body.x - other_body.x
            dy = body.y - other_body.y
            dz = body.z - other_body.z
            dist = :math.sqrt(dx * dx + dy * dy + dz * dz)
            acc - (body.mass * other_body.mass) / dist
          end)

        {kinetic + kinetic_energy, potential + potential_energy}
      end)

    kinetic + potential
  end
end
