extends Node3D

@export var scale_offset: Node3D

# ARMS
@export var shoulder_L: Node3D
@export var elbow_L: Node3D

@export var shoulder_R: Node3D
@export var elbow_R: Node3D

# LEGS
@export var ankle_L: Node3D
@export var knee_L: Node3D

@export var ankle_R: Node3D
@export var knee_R: Node3D



var scale_amplitude: float = 0.025
var arm_rot_amplitude: float = deg_to_rad(2.5)
var elbow_rot_amplitude: float = deg_to_rad(5)
var ankle_rot_amplitude: float = deg_to_rad(1)
var knee_rot_amplitude: float = deg_to_rad(3)

# Controls for snappy timing
var speed_min_factor: float = 0.6    # slowest multiplier (must be > 0)
var speed_max_factor: float = 2.0    # fastest multiplier
var speed_snap_pow: float = 3.0      # >1 sharpens peak, <1 flattens it


var curr_animation_value: float = 0.0
var animation_progress_per_sec: float = 1.0

func _process(delta: float) -> void:
	curr_animation_value = fposmod(curr_animation_value, 1.0) 
	
	var curr_rotation = curr_animation_value * PI * 2.0
	# ==========================================================================================================
	# AI GENERATED CURR ROTATION SPEED SNAPPINESS RELATED CODE

	# --- snappy curr_rotation update ---
	# compute a smooth signal that is 1 at curr_rotation == 0 or PI, 0 at PI/2 and 3PI/2
	var phase_signal: float = (1.0 + sin(curr_rotation * 1.0)) * 0.5   # in [0,1]

	# optionally sharpen the peaks (makes the "snap" more pronounced)
	var shaped_signal: float = pow(phase_signal, speed_snap_pow)

	# map shaped_signal into a speed factor between min and max
	var speed_factor: float = lerp(speed_min_factor, speed_max_factor, shaped_signal)
	
	curr_animation_value += animation_progress_per_sec * delta * speed_factor
	
	# keep curr_rotation in range
	curr_rotation = wrapf(curr_rotation, 0, (2.0 * PI))
	# ==========================================================================================================
	
	scale.x = 1.0 - solve_cos(curr_rotation, scale_amplitude, true)
	scale.y = 1.0 + solve_cos(curr_rotation, scale_amplitude, true)
	
	shoulder_L.rotation.z = solve_cos(curr_rotation, arm_rot_amplitude, true)
	shoulder_R.rotation.z = solve_cos(curr_rotation + PI, arm_rot_amplitude, false)
	
	elbow_L.rotation.z = solve_cos(curr_rotation, elbow_rot_amplitude, true)
	elbow_R.rotation.z = solve_cos(curr_rotation + PI, elbow_rot_amplitude, false)


	ankle_L.rotation.z = solve_cos(curr_rotation, ankle_rot_amplitude, true)
	knee_L.rotation.z = solve_cos(curr_rotation + PI, knee_rot_amplitude, false)
	#knee_L.rotation.z = solve_cos(curr_rotation + PI, arm_rot_amplitude, true)
	
	ankle_R.rotation.z = solve_cos(curr_rotation + PI, ankle_rot_amplitude, false)
	knee_R.rotation.z = solve_cos(curr_rotation, knee_rot_amplitude, true)
	#knee_R.rotation.z = solve_cos(curr_rotation + PI, arm_rot_amplitude, false)

func solve_cos(curr_rotation: float, amplitude: float, direction: bool = true) -> float:
	var solved_cos: float = cos(curr_rotation) * amplitude * -1.0
	if direction:
		solved_cos -= amplitude
	else:
		solved_cos += amplitude
	return solved_cos
