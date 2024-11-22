import { render, waitFor, screen } from '@testing-library/react';
import DiagramInfo from './index';

describe('DiagramInfo', () => {
  it('renders without error', async () => {
    render(<DiagramInfo />);
    
    // Use waitFor to assert asynchronous changes if needed
    await waitFor(() => {
      expect(screen.getByText('Expected Text')).toBeInTheDocument();
    }, { timeout: 1000 });
  });
});
