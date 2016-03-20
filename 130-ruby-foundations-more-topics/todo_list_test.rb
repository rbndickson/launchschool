require 'simplecov'
SimpleCov.start
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'todo_list'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    assert_equal(@todo1, @list.shift)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    assert_equal(@todo3, @list.pop)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_add_raise_type_error
    assert_raises(TypeError) { @list.add('string') }
    assert_raises(TypeError) { @list.add(99) }
  end

  def test_add
    todo4 = Todo.new("Make Dinner")
    @list << todo4
    assert_equal(todo4, @list.last)
  end

  def test_item_at_raise_index_error
    assert_raises(IndexError) { @list.item_at(42) }
  end

  def test_item_at
    assert_equal(@todo2, @list.item_at(1))
  end

  def test_mark_done_at_raise_index_error
    assert_raises(IndexError) { @list.mark_done_at(42) }
  end

  def test_mark_done_at
    @list.mark_done_at(1)
    assert_equal(@todo2.done, true)
    assert_equal(@todo3.done, false)
  end

  def test_mark_undone_at_raise_index_error
    assert_raises(IndexError) { @list.mark_undone_at(42) }
  end

  def test_mark_undone_at
    @todo1.done!
    @todo2.done!

    @list.mark_undone_at(0)

    assert_equal(@todo1.done, false)
    assert_equal(@todo2.done, true)
  end

  def test_done_bang
    @list.done!
    assert_equal(@todo1.done?, true)
    assert_equal(@todo2.done?, true)
    assert_equal(@todo3.done?, true)
  end

  def test_remove_at_raise_index_error
    assert_raises(IndexError) { @list.remove_at(42) }
  end

  def test_remove_at
    @list.remove_at(1)
    assert_equal([@todo1, @todo3], @list.to_a)
  end

  def test_to_s
    output = <<~OUTPUT
    ---- Today's Todos ----
    [ ] Buy milk
    [ ] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output.chomp, @list.to_s)
  end

  def test_to_s_one_done
    @todo2.done!

    output = <<~OUTPUT
    ---- Today's Todos ----
    [ ] Buy milk
    [X] Clean room
    [ ] Go to gym
    OUTPUT

    assert_equal(output.chomp, @list.to_s)
  end

  def test_to_s_list_all_done
    @list.done!

    output = <<~OUTPUT
    ---- Today's Todos ----
    [X] Buy milk
    [X] Clean room
    [X] Go to gym
    OUTPUT

    assert_equal(output.chomp, @list.to_s)
  end

  def test_each
    result = []
    @list.each { |todo| result << todo }
    assert_equal([@todo1, @todo2, @todo3], result)
  end

  def test_each_return_value
    returned_value = @list.each { |todo| nil }
    assert_equal(@list, returned_value)
  end

  def test_select
    @todo1.done!
    new_list = TodoList.new(@list.title)
    new_list.add(@todo1)

    assert_equal(new_list.title, @list.title)
    assert_equal(new_list.to_s, @list.select{ |todo| todo.done? }.to_s)
  end

  def test_find_by_title
    assert_equal(@todo1, @list.find_by_title('Buy milk'))
  end

  def test_all_done
    @todo1.done!
    @todo3.done!
    assert_equal([@todo1, @todo3], @list.all_done)
  end

  def test_all_not_done
    @todo1.done!
    assert_equal([@todo2, @todo3], @list.all_not_done)
  end

  def test_mark_done
    @list.mark_done('Clean room')
    assert_equal(true, @todo2.done?)
  end

  def test_mark_all_done
    @list.mark_all_done
    assert_equal(true, @list.done?)
  end

  def test_mark_all_undone
    @todo1.done!
    @todo2.done!
    @todo3.done!
    @list.mark_all_undone
    assert_equal(false, @todo1.done?)
    assert_equal(false, @todo2.done?)
    assert_equal(false, @todo3.done?)
  end
end
