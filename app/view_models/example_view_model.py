import ctypes

from PySide6.QtCore import Signal

from app.models import DeviceModel
from app.protocols import ExCommand, ExHeader
from app.view_models import DeviceViewModel


class ExViewModel(DeviceViewModel):
    hw_info_event = Signal(bytes)
    fw_info_event = Signal(bytes)
    sys_reg_event = Signal(bytes)
    sys_diag_event = Signal(bytes)
    sys_cfg_event = Signal(bytes)
    sys_time_event = Signal(bytes)

    def __init__(self, model: DeviceModel) -> None:
        super().__init__(model)
        self.events = {
            ExCommand.R_HW_INFO: self.hw_info_event,
            ExCommand.R_FW_INFO: self.fw_info_event,
            ExCommand.R_SYS_REG: self.sys_reg_event,
            ExCommand.R_SYS_DIAG: self.sys_diag_event,
            ExCommand.RW_SYS_CFG: self.sys_cfg_event,
            ExCommand.RW_SYS_TIME: self.sys_time_event,
        }

    def receive_complete_cb(self, data: bytes) -> None:
        hdr = ExHeader.from_buffer_copy(data[: ctypes.sizeof(ExHeader)])
        cmd = ExCommand(hdr.u16_cmd)
        event = self.events.get(cmd, None)
        if event:
            event.emit(data[ctypes.sizeof(ExHeader) : -ctypes.sizeof(ctypes.c_uint16)])
