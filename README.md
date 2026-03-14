# ros-kill-all ☠️

![Build and Test](https://github.com/iameijaz/ros-kill-all/actions/workflows/build-and-test.yml/badge.svg)

Force-clear all ROS2 and DDS processes after a crash, hang, or failed launch.

No more hunting for ghost nodes, zombie publishers, or leftover DDS participants.
One command — clean slate.

## The problem

Your ROS2 launch crashes. You relaunch. It fails because:
- A node from the previous run is still holding a topic
- The ROS2 daemon is in a bad state
- A FastDDS participant is still advertising on the network
- Gazebo left a `gzserver` process behind

You end up running `ps aux | grep ros2` and killing PIDs one by one.
`ros-kill-all` does it in one shot.

## Installation

```bash
git clone https://github.com/iameijaz/ros-kill-all.git
cd ros-kill-all
sudo make install
```

Or without cloning:
```bash
sudo curl -o /usr/local/bin/ros-kill-all \
  https://raw.githubusercontent.com/iameijaz/ros-kill-all/main/ros-kill-all
sudo chmod +x /usr/local/bin/ros-kill-all
```

## Usage

```bash
ros-kill-all                  # kill all ROS2 + DDS processes
ros-kill-all --dry-run        # preview what would be killed
ros-kill-all --list           # show all running ROS2/DDS processes
ros-kill-all --node /slam     # kill one node by name
ros-kill-all --daemon         # kill only the ROS2 daemon
ros-kill-all --dds            # kill only DDS middleware
ros-kill-all --gazebo         # also kill Gazebo/Ignition
ros-kill-all --force          # SIGKILL instead of SIGTERM
ros-kill-all --verbose        # show full cmdline of each process
```

## What it kills

| Category | Processes |
|----------|-----------|
| ROS2 nodes | `ros2`, component containers, param server, ros-args |
| ROS2 daemon | `_ros2_daemon` (graceful stop first, then kill) |
| FastDDS | `fastrtps`, `fastdds`, `rmw_fastrtps` |
| CycloneDDS | `cyclonedds`, `rmw_cyclone` |
| Other RMW | Connext, OpenSplice, GuruDDS |
| Gazebo (opt) | `gzserver`, `gzclient`, `gz sim`, `ign gazebo` |

## Example output

```
ros-kill-all v1.0.0
────────────────────────────────────

▸ ROS2 daemon
  ✓ daemon stopped gracefully

▸ ROS2 nodes (3 found)
  14823    python3              ros2 run nav2_bringup bringup_launch...
  14901    component_container  /opt/ros/humble/lib/nav2_util/...
  15102    python3              ros2 run slam_toolbox async_slam...
  ✓ killed PID 14823
  ✓ killed PID 14901
  ✓ killed PID 15102

▸ DDS middleware (1 found)
  14820    fastrtps             /opt/ros/humble/lib/...
  ✓ killed PID 14820

Done. ROS2 environment cleared.
Tip: source your workspace again before launching nodes.
```

## Behaviour

- Sends `SIGTERM` first, waits 500ms, then `SIGKILL` for survivors
- Never kills its own PID or parent PID
- `--dry-run` is always safe — shows exactly what would happen
- Works with any ROS2 distribution (Humble, Iron, Jazzy, Rolling)
- Works with any DDS middleware (FastDDS, CycloneDDS, Connext)

## Requirements

- Linux (bash 4+)
- No ROS2 installation required to run

## License

MIT — see [LICENSE](LICENSE)

---

*Part of the [Verbit](https://github.com/iameijaz) robotics utility toolkit.*
*Related: [netwatch](https://github.com/iameijaz/netwatch) · [dmitree](https://github.com/iameijaz/dmitree)*
