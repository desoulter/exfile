defmodule Exfile.Backend do
  @moduledoc """

  """

  defstruct(
    backend_mod: nil,
    backend_name: nil,
    directory: "",
    max_size: nil,
    hasher: nil,
    meta: %{}
  )

  @type backend :: map
  @type file_id :: String.t
  @type uploadable :: pid() | Exfile.File.t

  @callback init(map) :: {:ok, backend} | {:error, atom}

  @callback upload(backend, uploadable) :: {:ok, Exfile.File.t} | {:error, atom}
  @callback get(backend, file_id) :: Exfile.File.t

  @callback delete(backend, file_id) :: :ok | {:error, :file.posix}
  @callback open(backend, file_id) :: {:ok, :file.io_device} | {:error, :file.posix}
  @callback size(backend, file_id) :: {:ok, pos_integer} | {:error, :file.posix}
  @callback exists?(backend, file_id) :: boolean
  @callback path(backend, file_id) :: Path.t

  defmacro __using__(_) do
    quote do
      @behaviour Exfile.Backend

      def init(opts) do
        {:ok, %Exfile.Backend{
          backend_mod: __MODULE__,
          backend_name: Dict.get(opts, :name),
          directory: opts.directory,
          max_size: opts.max_size,
          hasher: opts.hasher
        }}
      end

      def get(backend, id) do
        %Exfile.File{backend: backend, id: id}
      end

      def clear!(backend) do
        {:error, :notimpl}
      end

      def path(backend, id) do
        Path.join(backend.directory, id)
      end

      defoverridable [init: 1]
      defoverridable [get: 2]
      defoverridable [clear!: 1]
      defoverridable [path: 2]
    end
  end

  @doc """
  A convenience function to call `backend.backend_mod.upload(backend, uploadable)
  """
  def upload(backend, uploadable) do
    backend.backend_mod.upload(backend, uploadable)
  end

  @doc """
  A convenience function to call `backend.backend_mod.get(backend, file_id)
  """
  def get(backend, file_id) do
    backend.backend_mod.get(backend, file_id)
  end

  @doc """
  A convenience function to call `backend.backend_mod.delete(backend, file_id)
  """
  def delete(backend, file_id) do
    backend.backend_mod.delete(backend, file_id)
  end

  @doc """
  A convenience function to call `backend.backend_mod.open(backend, file_id)
  """
  def open(backend, file_id) do
    backend.backend_mod.open(backend, file_id)
  end

  @doc """
  A convenience function to call `backend.backend_mod.size(backend, file_id)
  """
  def size(backend, file_id) do
    backend.backend_mod.size(backend, file_id)
  end

  @doc """
  A convenience function to call `backend.backend_mod.exists?(backend, file_id)
  """
  def exists?(backend, file_id) do
    backend.backend_mod.exists?(backend, file_id)
  end

  @doc """
  A convenience function to call `backend.backend_mod.path(backend, file_id)
  """
  def path(backend, file_id) do
    backend.backend_mod.path(backend, file_id)
  end
end
