"""Performance configuration for 60 FPS optimization in Python SDK."""

import time
from typing import Optional, Dict, Any

class PerformanceConfig:
    """Performance configuration for 60 FPS optimization."""
    
    TARGET_FRAME_DURATION = 1.0 / 60.0  # ~16.67ms for 60 FPS
    MAX_FPS = 60
    
    _last_frame_time: Optional[float] = None
    _frame_count = 0
    _last_fps_update = 0.0
    _initialized = False
    
    @classmethod
    def initialize(cls) -> None:
        """Initialize performance configuration."""
        if cls._initialized:
            return  # Avoid re-initialization
        
        now = time.monotonic()
        cls._last_frame_time = now
        cls._last_fps_update = now
        cls._frame_count = 0
        cls._initialized = True
        print("Conduit 60 FPS performance initialized")
    
    @classmethod
    def should_skip_frame(cls) -> bool:
        """Check if current frame should be skipped to maintain 60 FPS."""
        if not cls._initialized:
            cls.initialize()
        
        current_time = time.monotonic()
        if cls._last_frame_time is None:
            cls._last_frame_time = current_time
            return False
        
        time_since_last_frame = current_time - cls._last_frame_time
        if time_since_last_frame < cls.TARGET_FRAME_DURATION:
            return True
        cls._last_frame_time = current_time
        return False
    
    @classmethod
    def update_frame_timing(cls) -> Optional[float]:
        """Update frame timing and return current FPS if available."""
        if not cls._initialized:
            cls.initialize()
        
        current_time = time.monotonic()
        cls._frame_count += 1
        
        if current_time - cls._last_fps_update >= 1.0:
            fps = cls._frame_count / (current_time - cls._last_fps_update)
            cls._frame_count = 0
            cls._last_fps_update = current_time
            cls._last_frame_time = current_time
            return fps
        
        cls._last_frame_time = current_time
        return None
    
    @classmethod
    def get_performance_stats(cls) -> Dict[str, Any]:
        """Get current performance statistics."""
        current_time = time.monotonic()
        return {
            "target_fps": cls.MAX_FPS,
            "target_frame_duration_ms": cls.TARGET_FRAME_DURATION * 1000,
            "frame_count": cls._frame_count,
            "last_fps_update": cls._last_fps_update,
            "current_time": current_time,
            "initialized": cls._initialized,
        }
    
    @classmethod
    def reset(cls) -> None:
        """Reset performance tracking."""
        cls._initialized = False
        cls._last_frame_time = None
        cls._frame_count = 0
        cls._last_fps_update = 0.0

# Global performance instance
performance_config = PerformanceConfig()

# Convenience function for easy access
def enable_60fps() -> None:
    """Enable 60 FPS performance optimization."""
    PerformanceConfig.initialize()
