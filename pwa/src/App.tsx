import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ToastProvider } from './components/Toast';
import { InstallPage } from './features/install/InstallPage';
import { HomePage } from './features/home/HomePage';
import { CharacterEditPage } from './features/character-edit/CharacterEditPage';
import { SummoningPage } from './features/summoning/SummoningPage';
import { ResultPage } from './features/result/ResultPage';
import { ElementalTemplatesPage } from './features/elemental-templates/ElementalTemplatesPage';
import { ElementalTemplateEditPage } from './features/elemental-templates/ElementalTemplateEditPage';

export default function App() {
  return (
    <BrowserRouter>
      <ToastProvider>
        <Routes>
          <Route path="/" element={<InstallPage />} />
          <Route path="/home" element={<HomePage />} />
          <Route path="/character/new" element={<CharacterEditPage />} />
          <Route path="/character/:id" element={<CharacterEditPage />} />
          <Route path="/summon/:characterId" element={<SummoningPage />} />
          <Route path="/result" element={<ResultPage />} />
          <Route path="/character/:id/elementals" element={<ElementalTemplatesPage />} />
          <Route path="/character/:id/elementals/new" element={<ElementalTemplateEditPage />} />
          <Route path="/character/:id/elementals/:templateId" element={<ElementalTemplateEditPage />} />
          {/* Fallback */}
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </ToastProvider>
    </BrowserRouter>
  );
}
