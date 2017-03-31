defmodule Que.QueueSet do
  defstruct queues: %{}


  @doc """
  Returns a new QueueSet with defaults
  """
  def new do
    %Que.QueueSet{}
  end



  @doc """
  Finds the Queue for a specified worker. If the queue does not
  exist, returns a new Queue for that worker.
  """
  def get(%Que.QueueSet{} = qset, worker) do
    qset.queues[worker] || Que.Queue.new(worker)
  end



  @doc """
  Adds a Job to the appropriate Queue in a QueueSet
  """
  def add(%Que.QueueSet{} = qset, %Que.Job{} = job) do
    q =
      qset
      |> Que.QueueSet.get(job.worker)
      |> Que.Queue.push(job)

    %{ qset | queues: Map.put(qset.queues, job.worker, q) }
  end



  @doc """
  Finds a Job in the QueueSet by the given Job's id and updates
  (replaces) it with the specified Job
  """
  def update(%Que.QueueSet{} = qset, %Que.Job{} = job) do
    q =
      qset
      |> Que.QueueSet.get(job.worker)
      |> Que.Queue.update(job)

    %{ qset | queues: Map.put(qset.queues, job.worker, q) }
  end



  @doc """
  Removes the specified job from the appropriate Queue's running list
  """
  def remove(%Que.QueueSet{} = qset, %Que.Job{} = job) do
    q =
      qset
      |> Que.QueueSet.get(job.worker)
      |> Que.Queue.remove(job)

    %{ qset | queues: Map.put(qset.queues, job.worker, q) }
  end



  @doc """
  Groups a list of Jobs into a proper QueueSet. All Jobs are loaded
  only in the :queued list
  """
  def collect(jobs) when is_list(jobs) do
    queues =
      jobs
      |> Enum.group_by(&(&1.worker))
      |> Enum.map(fn {w, j} -> {w, Que.Queue.new(w, j)} end)
      |> Enum.into(%{})

    %Que.QueueSet{ queues: queues }
  end



  def find_by_ref(qset, ref)

end