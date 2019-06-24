# 
# Synthesis run script generated by Vivado
# 

set TIME_start [clock seconds] 
proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.cache/wt} [current_project]
set_property parent.project_path {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.xpr} [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo {c:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.cache/ip} [current_project]
set_property ip_cache_permissions {read write} [current_project]
read_verilog -library xil_defaultlib -sv {
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/ALUControl.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/imports/MyRISCyCPU/CPU.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/Control.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/Execute.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/ForwardingUnit.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/HazardDetection.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/InstructionCache.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/InstructionDecode.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/InstructionFetch.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/Interfaces.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/Memory.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/imports/MyRISCyCPU/RegisterFile.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/Writeback.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/imports/MyRISCyCPU/alu.sv}
  {C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/new/CPU_tb.sv}
}
read_ip -quiet {{C:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/ip/RAM/RAM.xci}}
set_property used_in_implementation false [get_files -all {{c:/Users/xoepe/Documents/VIP/Final Report/cpu/cpu.srcs/sources_1/ip/RAM/RAM_ooc.xdc}}]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
set_param ips.enableIPCacheLiteLoad 1
close [open __synthesis_is_running__ w]

synth_design -top CPU_tb -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef CPU_tb.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file CPU_tb_utilization_synth.rpt -pb CPU_tb_utilization_synth.pb"
file delete __synthesis_is_running__
close [open __synthesis_is_complete__ w]
