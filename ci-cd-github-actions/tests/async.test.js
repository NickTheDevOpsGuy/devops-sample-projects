function fetchData() {
    return new Promise(resolve => {
      setTimeout(() => resolve('DevOps Rocks'), 100);
    });
  }
  
  test('resolves async data', async () => {
    const data = await fetchData();
    expect(data).toBe('DevOps Rocks');
  });
  