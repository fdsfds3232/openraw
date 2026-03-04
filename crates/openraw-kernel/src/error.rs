//! Kernel-specific error types.

use openraw_types::error::OpenRawError;
use thiserror::Error;

/// Kernel error type wrapping OpenRawError with kernel-specific context.
#[derive(Error, Debug)]
pub enum KernelError {
    /// A wrapped OpenRawError.
    #[error(transparent)]
    OpenRaw(#[from] OpenRawError),

    /// The kernel failed to boot.
    #[error("Boot failed: {0}")]
    BootFailed(String),
}

/// Alias for kernel results.
pub type KernelResult<T> = Result<T, KernelError>;
